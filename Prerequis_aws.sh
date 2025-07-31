# 1. Create VPC
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=my-vpc}]'

# Save the VPC ID
VPC_ID=$(aws ec2 describe-vpcs --filters Name=cidr-block,Values=10.0.0.0/16 --query 'Vpcs[0].VpcId' --output text)

# 2. Enable DNS support (optional but useful)
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames

# 3. Create Subnet A (eu-west-3a)
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.1.0/24 \
  --availability-zone eu-west-3a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=my-subnet-a}]'

# 4. Create Subnet B (eu-west-3b)
aws ec2 create-subnet \
  --vpc-id $VPC_ID \
  --cidr-block 10.0.2.0/24 \
  --availability-zone eu-west-3b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=my-subnet-b}]'

SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[*].{ID:SubnetId,AZ:AvailabilityZone,CIDR:CidrBlock,Name:Tags[?Key=='Name']|[0].Value}" \
  --output table)