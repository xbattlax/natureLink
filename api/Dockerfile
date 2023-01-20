FROM python:latest
WORKDIR /code
ADD requirement.txt requirement.txt
RUN pip install -r requirement.txt
RUN export PYTHONPATH=$PWD
EXPOSE 8000
COPY . /code/api
CMD ["python", "api/main.py"]