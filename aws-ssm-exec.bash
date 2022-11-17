run_command () {
  instanceId=$1
  cmd="${@:2}"
  echo "------------------------------------------ Launch Command Arguments -------------------------------------------"
  echo $cmd

  cmdId=$(aws ssm send-command --instance-ids $instanceId --document-name "AWS-RunShellScript" --query "Command.CommandId" --parameters "commands=$cmd" --output text)
  echo $cmdId

  while [ $(aws ssm list-command-invocations --command-id $cmdId --query "CommandInvocations[0].Status") = '"InProgress"' ]
  do
    echo "Sill InProgress"
    sleep 10
  done

  status=$(aws ssm list-command-invocations --command-id $cmdId --query "CommandInvocations[0].Status")

  echo "------------------------------------------ Exec Status -------------------------------------------"
  echo $status

  if [ $status = '"Success"' ]; then
      echo $cmd "terminated with success"
      exit 0
  else 
      exit 1
  fi
    
}
