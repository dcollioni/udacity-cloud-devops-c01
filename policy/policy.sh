# create policy definition using rules
az policy definition create --name tagging-policy --rules ./tagging-policy-rules.json --params ./tagging-policy-params.json 

# create policy assignment
az policy assignment create --name tagging-policy --policy tagging-policy -p "{ \"tagName\": { \"value\": \"udacity\" } }"

# list existing policy assignments
az policy assignment list
