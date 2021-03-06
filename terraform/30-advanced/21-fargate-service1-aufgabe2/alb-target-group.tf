resource "aws_lb_target_group" "this" {
  // better: use a random string as suffix to guarantee a unique name to allow create_before_destroy option
  // https://www.terraform.io/docs/providers/random/r/string.html
  // max length 32 characters
  name = "${local.service_name}"
  port = 80
  protocol = "HTTP"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  deregistration_delay = 10
  target_type = "ip"

  health_check {
    healthy_threshold = 2
    interval = 5
    timeout = 2
    unhealthy_threshold = 2
    port = 80
    path = "/service1/health"
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = "${local.default_tags}"
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = "${data.terraform_remote_state.vpc.alb_listener_arn}"
  priority = 1

  action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.this.arn}"
  }

  condition {
    field = "path-pattern"
    values = ["/service1/*"]
  }
}

resource "aws_security_group" "this" {
  name = "${local.service_name}"
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = ["${data.terraform_remote_state.vpc.alb_security_group_id}"]
  }

  egress {
    from_port = 0
    // all
    to_port = 0
    // all
    protocol = "-1"
    // all
    cidr_blocks = ["0.0.0.0/0"]
  }

}