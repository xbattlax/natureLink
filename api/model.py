from sqlalchemy import Column
from sqlalchemy import ForeignKey
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Date
from sqlalchemy import Float
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import relationship

Base = declarative_base()

class Utilisateur(Base):
     __tablename__ = "utilisateur"

     id_utilisateur = Column(Integer, primary_key=True)
     access_token = Column(UUID, nullable=False)
     username = Column(String(50), nullable=False)
     password = Column(String, nullable=False)
     email = Column(String)
     nom = Column(String(30))
     prenom = Column(String)
     date_naissance = Column(Date)
     telephone = Column(String)
     adresse = Column(String)
     right = relationship("Droit", back_populates="utilisateur")


     def __repr__(self):
         return f"Utilisateur(id={self.id_utilisateur!r}, nom={self.nom!r}, prenom={self.prenom!r})"

class Droits(Base):
     __tablename__ = "droits"

     id = Column(Integer, primary_key=True)
     name = Column(String, nullable=False)


     def __repr__(self):
         return f"Droits(id={self.id!r}, email_address={self.name!r})"

class positionGPS(Base):
     __tablename__ = "positionGPS"

     id = Column(Integer, primary_key=True)
     latitude = Column(Float)
     longitude = Column(Float)
     altitude = Column(Float)
     distance = Column(Integer)
     date = Column(Date)
     belongsTo = Column(Integer, ForeignKey("utilisateur.id_utilisateur"))
     def __repr__(self):
         return f"positionGPS(id={self.id!r}, id_utilisateur={self.id_utilisateur!r}, latitude={self.latitude!r}, longitude={self.longitude!r}, date={self.date!r})"

