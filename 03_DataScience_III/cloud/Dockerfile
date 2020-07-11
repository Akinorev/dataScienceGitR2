FROM python:3

WORKDIR /usr/src/app

#Installing primary requirments
RUN apt-get update
RUN apt-get -y install build-essential libpoppler-cpp-dev pkg-config python-dev

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

#Install language package
RUN python -m spacy download en_core_web_sm

COPY ./data/j-r-r-tolkien-lord-of-the-rings-01-the-fellowship-of-the-ring.pdf .
COPY ./scripts/autoResume2.py .

ENTRYPOINT [ "python", "autoResume2.py", "j-r-r-tolkien-lord-of-the-rings-01-the-fellowship-of-the-ring.pdf", "20" ]