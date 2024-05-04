# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies required for lxml and other packages
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Creating a non-root user and switch to it
RUN useradd -m myuser

# Change ownership of the /app directory to myuser
RUN chown -R myuser:myuser /app

# Switch to non-root user
USER myuser

# Setup virtual environment
RUN python -m venv venv
ENV PATH="/app/venv/bin:$PATH"

# Copy the current directory contents into the container at /app
COPY --chown=myuser:myuser . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run wsgi.py when the container launches
CMD ["python", "wsgi.py"]
