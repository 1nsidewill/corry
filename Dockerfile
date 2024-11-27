# Start with a lightweight Python 3.11 image
FROM python:3.11.10

# Set the working directory in the container to /app
WORKDIR /app

# Copy only the necessary files to leverage Docker caching for dependencies
COPY pyproject.toml poetry.lock /app/

# Install Poetry
RUN pip install poetry && \
    poetry config virtualenvs.in-project true && \
    poetry install --no-root

# Copy the entire project into the container
COPY . /app

# Set environment to deployment
ENV ENVIRONMENT=dev

# 설정할 포트 번호를 아래 두 줄에 작성해줍니다.
# Expose the port your FastAPI app will run on
EXPOSE 8701

# Command to run database migrations and start the FastAPI app
CMD ["sh", "-c", "poetry run alembic upgrade head && poetry run uvicorn src.main:app --host 0.0.0.0 --port 8701"]