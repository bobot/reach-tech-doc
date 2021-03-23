# FROM python:3

# RUN pip install -U sphinx

FROM nginx

ADD build/html /usr/share/nginx/html