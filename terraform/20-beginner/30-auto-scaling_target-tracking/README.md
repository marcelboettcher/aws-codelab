# Auto-Scaling - Target Tracking

# Goal
If we measure high load on our service (e.g. cpu, memory, requests, ...), we want to scale out. 


## Task
0. Build on task *ec2_asg-alb*
0. Create an autoscaling policy
    - using scaling type *target tracking*
    - predefined metric *ALBRequestCountPerTarget*
0. run a load test on your application to see it scale
    - run in shell `watch -n 3 "curl -s http://your-alb-dns-name/service1/health"` or refresh site in browser
    - Service should scale after 3 minutes of more than 10 request per minute
    - watch web console: EC2 -> Load Balancing -> Target Groups -> Targets
    - watch web console: EC2 -> Auto Scaling -> Auto Scaling Groups -> Instances and Activity History
0. Run terraform apply after instances are scaled to 1 or 3. What happens?
    - Solve the issue by adding `lifecycle { ignore_changes = ["desired_capacity"] }` to *aws_autoscaling_group*    
    


## Hints
<details><summary>Show Hint 1</summary><p>

You need three data sources and one resource.
</p></details>


<details><summary>Show Hint 2</summary><p>

Data Sources: aws_autoscaling_groups, aws_lb, aws_lb_target_group</br>
Resources: aws_autoscaling_policy
</p></details>
