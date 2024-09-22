exports.handler = async (event) => {
  console.log('Event:', JSON.stringify(event));

  const token = event.authorizationToken;

  // Exemplo de verificação de token simples (pode ser JWT ou outro tipo)
  if (token === 'allow') {
    return generatePolicy('user', 'Allow', event.methodArn, event);
  } else if (token === 'deny') {
    return generatePolicy('user', 'Deny', event.methodArn, event);
  } else {
    return generatePolicy('user', 'Allow', event.methodArn, event);
    // return {message: 'ok'}
    // throw new Error('Unauthorized');
  }
};

// Função auxiliar para gerar uma política de autorização
const generatePolicy = (principalId, effect, resource, data) => {
  const authResponse = {};
  authResponse.principalId = principalId;

  if (effect && resource) {
    const policyDocument = {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Effect: effect,
          Resource: resource,
        },
      ],
    };
    authResponse.policyDocument = policyDocument;
  }

  // Opcional: Adicione informações de contexto para passar ao backend
  authResponse.context = {
    userRole: 'admin',
    userName: 'exampleUser',
    data,
  };

  return authResponse;
};
