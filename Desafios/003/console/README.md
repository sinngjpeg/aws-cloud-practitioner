Criando seu primeiro site na AWS com EC2 e UseData

Se você está começando agora no mundo da **nuvem** e quer colocar um site simples no ar, parabéns, essa é uma das experiências mais legais que você pode ter no início. Neste artigo, vamos criar **nossa primeira instância EC2** e usá-la para hospedar um **site estático**, tudo dentro do **nível gratuito (Free Tier)** da AWS.

**O que é o EC2?**

Pense no **EC2 (Elastic Compute Cloud)** como um **computador virtual** dentro da nuvem da AWS. Você pode ligar, desligar, configurar e até deletar esse servidor em poucos cliques sem precisar de nenhum hardware físico.

Ele é muito usado para hospedar:

- Sites e APIs,
- Aplicações backend,
- Bancos de dados,
- E até servidores de jogos!

**O que são “dados de usuário” (User Data)?**

Quando criamos uma instância EC2, podemos mandar um **script** para ela executar automaticamente assim que for iniciada. Esse script é o que chamamos de **User Data** e serve para automatizar tarefas, como:

- Instalar pacotes (ex: Apache, Nginx),
- Criar arquivos
- Rodar configurações iniciais.

Ou seja, você **liga a instância** e **ela já faz tudo sozinha**, sem precisar entrar via SSH para configurar manualmente. Bem prático, né?

**Mão na massa: Criando seu primeiro site com EC2**

Vamos agora criar uma instância EC2 com **Amazon Linux 2**, totalmente dentro do **Free Tier** da AWS.

**1. Acesse o Console da AWS**

Entre em https://console.aws.amazon.com e procure por **EC2**. No painel, clique em **Instances → Launch Instances**.

**2. Dê um nome para sua instância**

No campo “Name and tags”, digite: My First Instance

![Minha Primeira Estancia](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/sosbns35cu1vr5a9nqry.png)

**3. Escolha a imagem (AMI)**

Selecione: Amazon Linux 2 AMI (HVM), SSD Volume Type – 64-bit (x86). Essa versão é leve, rápida e gratuita por 12 meses dentro do Free Tier.

![Amazon Linux 2 AMI](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/kvd4w71mpmfqsk36zlvj.png)

**4. Escolha o tipo da instância**

Selecione: t3.micro. Esse tipo é gratuito (até 750 horas por mês).

![t3.micro](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/wq2ph02aj1v4y5kcxvpn.png)

**5. Crie ou escolha um par de chaves (Key Pair)**

Crie um novo par de chaves, por exemplo: ec2-tutorial-key. Baixe o arquivo .pem ele será necessário se você quiser acessar a instância via SSH.

![ec2-tutorial-key](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/h6xmtkn6req0oxky801p.png)

**6. Configure a rede (Security Group)**

ative as seguintes configurações:

- Allow SSH traffic from
- Allow HTTP traffic from internet

![Securirty Group](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jj5qbs3jhv977mn3o1px.png)

**7. Dados do usuário (User Data)**

No final da página, abra a seção **Advanced details → User data** e cole o script abaixo:

```
#!/bin/bash
# Atualiza os pacotes
yum update -y

# Instala o servidor web Apache
yum install -y httpd

# Inicia o Apache e configura para iniciar automaticamente
systemctl start httpd
systemctl enable httpd

# Cria um arquivo HTML simples
echo "<html><body><h1>Hello World from EC2!</h1></body></html>" > /var/www/html/index.html
```

Esse script vai instalar o Apache e criar uma página web com a mensagem **“Hello World from EC2!”**

**8. Revise e inicie**

Revise tudo e clique em **Launch Instance**. Depois, vá até **View all instances** e aguarde o status mudar para **Running**.

**Acessando seu site**

Assim que a instância estiver “Running”:

1. Copie o **Endereço IPv4 público**,
2. Abra o navegador e digite: http://seu-endereco-ip

Pronto! Você verá seu site com o “Hello World”.

![Visualização do Site](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ybtswh3yhejjx3am9xjf.png)

**Extras que você vai aprender nesse processo**

Ao fazer esse exercício, você aprende conceitos fundamentais da AWS:

- O que é uma **instância EC2**,
- Como funcionam **imagens (AMI)** e **tipos de instância**,
- O que é um **Security Group** (como um “firewall”),
- Como automatizar configurações com **User Data**,
- E até como **iniciar, parar e encerrar** uma instância.

**Dica importante**

Sempre que **parar** e **iniciar** novamente sua instância, o **endereço IP público muda** (a menos que você use um _Elastic IP_). Então, se o site parar de funcionar depois de reiniciar, copie o novo IP e atualize o link.

**Encerrando a instância**

Quando terminar os testes:

- Vá em **Instance state → Terminate** para encerrar.
- Isso libera recursos e evita custos.

Você acabou de criar seu **primeiro servidor web na nuvem da AWS** sem precisar configurar hardware, sem pagar nada e com apenas alguns cliques.

Esse tipo de prática é perfeita para:

- Entender como funcionam servidores e IPs,
- Aprender o básico da infraestrutura em nuvem,
- E dar os primeiros passos rumo ao mundo **DevOps e Cloud**.

Continue explorando o EC2, brinque com os scripts e, aos poucos, vá adicionando novas funcionalidades. O importante é **experimentar** e **aprender com a prática**.
