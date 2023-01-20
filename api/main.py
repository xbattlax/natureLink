import uvicorn
from fastapi import FastAPI, HTTPException
from bcrypt import hashpw, gensalt, checkpw
from sqlalchemy import create_engine
from sqlalchemy import select
from sqlalchemy.orm import Session
from fastapi.middleware import Middleware
from fastapi.middleware.cors import CORSMiddleware

from model import Utilisateur, positionGPS

middleware = [
    Middleware(
        CORSMiddleware,
        allow_origins=['*'],
        allow_credentials=True,
        allow_methods=['*'],
        allow_headers=['*']
    )
]

db_name = 'database'
db_user = 'username'
db_pass = 'secret'
db_host = 'db'
db_port = '5432'

db_string = 'postgresql://{}:{}@{}:{}/{}'.format(db_user, db_pass, db_host, db_port, db_name)
db = create_engine(db_string)

app = FastAPI(middleware=middleware)


def get_hashed_password(plain_text_password):
    # Hash a password for the first time
    #   (Using bcrypt, the salt is saved into the hash itself)
    return hashpw(plain_text_password, gensalt())


def check_password(plain_text_password, hashed_password):
    # Check hashed password. Using bcrypt, the salt is saved into the hash itself
    return checkpw(plain_text_password, hashed_password)


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.post("/connexion")
async def connexion(user: str, passwd: str):
    if user is None or passwd is None or user == "" or passwd == "":
        return HTTPException(status_code=400,
                             detail={"message": "requette invalide"})
    user = select(Utilisateur.username == user).first()
    if user is not None:
        if check_password(passwd, user.password):
            raise {"message": "Connexion réussie", "token": user.access_token}
        else:
            return HTTPException(status_code=404,
                                 detail={"message": "Mot de passe incorrect ou nom d'utilisateur incorrect"})
    else:
        return HTTPException(status_code=404,
                             detail={"message": "Mot de passe incorrect ou nom d'utilisateur incorrect"})


@app.post("/inscription")
async def inscription(json: dict):
    print(json)
    if json['username'] is None or json['password'] is None or json['email'] is None or json['nom'] is None \
            or json['prenom'] is None or json['date_naissance'] is None or json['telephone'] is None or json['adresse'] is None:
        return HTTPException(status_code=400,
                             detail={"message": "requette invalide"})
    user = select(Utilisateur.username == json['username'])
    print(user.id)
    if user is not None:
        return HTTPException(status_code=404,
                             detail={"message": "Ce nom d'utilisateur existe déjà"})
    else:
        user = select(Utilisateur.email == json['email']).first()
        if user is not None:
            return HTTPException(status_code=404,
                                 detail={"message": "Cette adresse email existe déjà"})
        else:
            user = Utilisateur(username=json['username'], password=get_hashed_password(json['password']),
                               email=json['email'], nom=json['nom'], prenom=json['prenom'],
                               date_naissance=json['date_naissance'],
                               telephone=json['telephone'], adresse=json['adresse'], right= 2)
            session = Session(db)
            session.add(user)
            session.commit()
            user = select(Utilisateur.username == json['username']).first()
            if user is not None:
                return {"message": "Inscription réussie", "token": user.access_token}
            else:
                return HTTPException(status_code=404,
                                     detail={"message": "Inscription échouée"})

@app.get("/posGps")
async def posGps(east: float, north:float, south:float, west:float):
    arr = select(positionGPS).filter( positionGPS.east < east, positionGPS.north < north, positionGPS.south > south, positionGPS.west > west).all()
    arr = [dict(row) for row in arr]
    return arr

@app.post("/posGps")
async def posGps(json):
    if json['access_token'] is None:
        return HTTPException(status_code=400,
                             detail={"message": "requette invalide"})
    user = select(Utilisateur.access_token == json['access_token']).first()
    if user is not None:
        if user.right == 1 or user.right == 2:
            pos = positionGPS(latitude=json['latitude'], longitude=json['longitude'], altitude=json['altitude'], distance=json['distance'], date= json['date'], belongTo=user.id)
            session = Session(db)
            session.add(pos)
            session.commit()
        else :
            return HTTPException(status_code=404,
                                 detail={"message": "Vous n'avez pas les droits pour effectuer cette action"})
    else:
        return HTTPException(status_code=404,
                             detail={"message": "Vous n'avez pas les droits pour effectuer cette action"})
    return {"message": "Position ajoutée"}

@app.post("/nbPos")
async def nbPos(json):
    if json['access_token'] is None:
        return HTTPException(status_code=400,
                             detail={"message": "requette invalide"})
    user = select(Utilisateur.access_token == json['access_token']).first()
    if user is not None:
        pos = select(positionGPS.belongTo == user.id).count()
        return {"message": "Nombre de positions", "nb": pos}
    else:
        return HTTPException(status_code=404,
                             detail={"message": "Vous n'etes pas connecté"})

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8000)