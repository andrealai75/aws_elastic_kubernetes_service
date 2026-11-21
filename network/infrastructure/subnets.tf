resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 2, 0)
  availability_zone       = local.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${local.project}-public-a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(local.vpc_cidr, 2, 1)
  availability_zone       = local.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${local.project}-public-b"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(local.vpc_cidr, 2, 2)
  availability_zone = local.azs[0]

  tags = {
    Name                              = "${local.project}-private-a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(local.vpc_cidr, 2, 3)
  availability_zone = local.azs[1]

  tags = {
    Name                              = "${local.project}-private-b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
