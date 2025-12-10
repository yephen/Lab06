FROM python:3

WORKDIR /app

COPY frontend /app
RUN --mount=type=cache,target=/root/.cache/pip \
    pip3 install -r requirements.txt

EXPOSE 8080

ENTRYPOINT ["python3"]
CMD ["app.py"]