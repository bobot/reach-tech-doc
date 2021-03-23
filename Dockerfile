# FROM python:3

# RUN pip install -U sphinx

FROM nginx

ADD build /usr/share/nginx/html