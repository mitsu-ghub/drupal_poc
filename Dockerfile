FROM hashicorp/terraform:1.3.2
ENV AWS_ACCESS_KEY_ID=AKIA4XIVOBZOOEDKEQW6
ENV AWS_SECRET_ACCESS_KEY=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
ENV AWS_DEFAULT_REGION=us-east-1
COPY Infra Infra
WORKDIR /Infra
RUN terraform init
RUN terraform apply -target="aws_subnet.private_subnets" -auto-approve
RUN terraform apply -auto-approve


