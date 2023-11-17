# Añadir permisos directamente al rol asumido (Erik_Javaloya)
aws iam attach-role-policy --role-name voclabs/user2562510=Erik_Javaloya --policy-arn arn:aws:iam::aws:policy/AmazonRDSFullAccess

# Crear grupo de seguridad para la base de datos
bd_erik_cli=$(aws ec2 create-security-group --group-name gs-erik-cli --description "Grupo de seguridad para la base de datos" --output json --query 'GroupId' | tr -d '"')

# Abrir puerto 3306 para tráfico entrante
aws ec2 authorize-security-group-ingress --group-id $bd_erik_cli --protocol tcp --port 3306 --cidr 0.0.0.0/0

# Crear instancia de RDS con MySQL
aws rds create-db-instance \
  --db-instance-identifier mi-instancia-rds \
  --allocated-storage 20 \
  --db-instance-class db.t3.micro \
  --engine MySQL \
  --master-username root \
  --master-user-password root1234 \
  --vpc-security-group-ids $bd_erik_cli \
  --availability-zone us-east-1a \
  --db-name bd_erik_cli \
  --port 3306 \
  --multi-az

