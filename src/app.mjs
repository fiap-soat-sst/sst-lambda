import jwt from 'jsonwebtoken';
import aws from 'aws-sdk';

aws.config.update({ region: 'us-east-1' });
const dynamodb = new aws.DynamoDB.DocumentClient();


export const handler = async (event) => {
  const { headers, routeArn } = event;
  const { ["x-user-cpf"]: cpf, ["x-user-name"]: name, ["x-api-key"]: apiKey } = headers;

  let userExists = null;
  let token = null;

  if (cpf) {
    userExists = await checkUserByCpf(cpf);
  }

  if (cpf && name) {
    userExists ? await updateUserName(cpf, name) : await createUser(cpf, name, 'user');    
    token = generateToken({ cpf, name, type: 'user' });
  } else if (cpf && userExists) {
    token = generateToken({ cpf, name: userExists.name, type: 'user' });
  } else if (name) {
    token = generateToken({ name, type: 'unregistered user' });
  } else if (apiKey) {
    const userData = await getUserDataByApiKey(apiKey);
    if (userData) {
      token = generateToken({ name: userData.name, type: "admin" });
    }
  }

  if (token) {
    return generateAllowPolicyWithToken(routeArn, token);
  }

  return generateDenyPolicy(routeArn);
};


function generateToken(payload) {
  const secret = process.env.JWT_SECRET || '3k{${?^d45o1bja6you8d&k5m;+n)t$<${_!]1d/:=(:6j=d*|4::)]:!5{`]z_';
  return jwt.sign(payload, secret, { expiresIn: '1h' });
}

function generateAllowPolicyWithToken(resource, token) {
  return {
    principalId: "user",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: "Allow",
          Resource: resource,
        },
      ],
    },
    context: {
      token,
    },
  };
}

function generateDenyPolicy(resource) {
  return {
    principalId: "user",
    policyDocument: {
      Version: "2012-10-17",
      Statement: [
        {
          Action: "execute-api:Invoke",
          Effect: "Deny",
          Resource: resource,
        },
      ],
    },
  };
}

async function checkUserByCpf(cpf) {
  const params = {
    TableName: 'users',
    Key: {
      cpf,
    }
  };

  try {
    const data = await dynamodb.get(params).promise();
    if (data.Item) {
      return data.Item;
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
    return null;
  }
}

async function updateUserName(cpf, novoNome) {
  const params = {
    TableName: 'users',
    Key: { cpf },
    UpdateExpression: 'set #name = :name',
    ExpressionAttributeNames: {
      '#name': 'name',
    },
    ExpressionAttributeValues: {
      ':name': novoNome,      
    },
    ReturnValues: 'UPDATED_NEW'
  };

  try {
    const data = await dynamodb.update(params).promise();
    return data.Attributes;
  } catch (error) {
    console.log(error);
    return null;
  }
}

async function createUser(cpf, name, type) {
  const params = {
    TableName: 'users',
    Item: {
      cpf,
      name,
      type,
    }
  };

  try {
    await dynamodb.put(params).promise();
    return { cpf, name, type };
  } catch (error) {
    console.log(error);
    return null;
  }
}

async function getUserDataByApiKey(uuid) {
  const params = {
    TableName: 'users-admin',
    Key: {
      uuid,
    }
  };

  try {
    const data = await dynamodb.get(params).promise();
    if (data.Item) {
      return data.Item;
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
    return null;
  }
}