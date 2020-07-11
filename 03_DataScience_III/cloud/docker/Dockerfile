FROM python:3

WORKDIR /usr/src/app

# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt

COPY ./data .
COPY ./scripts .

CMD [ "python", "./autoResume2.py j-r-r-tolkien-lord-of-the-rings-01-the-fellowship-of-the-ring.pdf 20" ]