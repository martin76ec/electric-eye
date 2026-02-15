# Stage 1: Build Python dependencies
FROM python:3.13 AS builder-deps

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt -t /app/packages

# Stage 2: Install Git
FROM public.ecr.aws/lambda/python:3.13 AS builder-git

RUN dnf install -y git && dnf clean all

# Stage 3: Final image
FROM public.ecr.aws/lambda/python:3.13

WORKDIR /var/task

COPY --from=builder-deps /app/packages/ .

COPY --from=builder-git /usr/bin /usr/bin
COPY --from=builder-git /usr/libexec /usr/libexec
COPY --from=builder-git /usr/lib64 /usr/lib64
COPY --from=builder-git /usr/share /usr/share

COPY . .

CMD ["src.main.handler"]
