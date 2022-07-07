if aws s3api head-bucket --bucket "itaunetinfrasandbox"; then
    echo "Bucket does exist"
    exit
else cd terraform/infraestructure/s3_state; terraform init; terraform plan; terraform apply -auto-approve
fi