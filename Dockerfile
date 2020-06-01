# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

EXPOSE 8000

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y gunicorn
RUN pip install gunicorn

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED 1

# Install pip requirements
RUN pip install pipenv

WORKDIR /app
ADD . /app
RUN pipenv install --system --deploy
WORKDIR /app/pleiades
ENV PYTHONPATH=/app/pleiades

# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights
RUN useradd appuser && chown -R appuser /app
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "pleiades.wsgi:application"]
