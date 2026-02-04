# Projeto IntuitiveCare

## 📁 Estrutura do Projeto

- `integracao.ipynb`: referente as atividades do 1. TESTE DE INTEGRAÇÃO COM API PÚBLICA
- `transformacao.ipynb`: referente as atividades do 2. TESTE DE TRANSFORMAÇÃO E VALIDAÇÃO DE DADOS
- `ScriptsSQL/`: referente as atividades do 3. TESTE DE BANCO DE DADOS E ANÁLISE
- `web/`: referente as atividades do 4. TESTE DE API E INTERFACE WEB

## ⚙️ Pré-requisitos

### Python
- Python 3.8 ou superior.
- Instalar dependências via `pip install -r requirements.txt`.

### Node.js e npm
- Node.js 16 ou superior.
- npm (geralmente instalado junto com o Node.js).

### Banco de Dados
- PostgreSQL (utilizado pelo backend).

## 🚀 Instalação e Configuração

### 1. Clonagem e Dependências

Clone o repositório e navegue para a pasta do projeto:

```bash
git clone https://github.com/G4brielV/TesteIntuitiveCare.git
cd projeto-intuitivecare
``` 

### Dependências do Python

```bash
pip install -r requirements.txt
``` 

### Dependências do Node.js
Navegue para a pasta do frontend e instale as dependências:
```bash
cd web/frontend
npm install
```

# OBS: Escolhi por não subir todos os csvs e ZIPs por conta do armazenamento e limites do github, mas os códigos capturam da API corretamente e geram os asquivos necessários

# Principais pontos de cada etapa:
## 1. TESTE DE INTEGRAÇÃO COM API PÚBLICA - 
- **OBJETIVO:** Identifica e baixa os ZIP -> Extrai -> Consolida os 3 ultimos csvs -> Gera consolidado_despesas.zip
- **Processamento incremental:** Processamento dos CSVs em partes (chunks) para economizar memória. Caso a ocorrência desejada seja encontrada nos primeiros blocos, o processamento é interrompido.
- **Consolidação:**
  - **OBS:** Como nas demonstrações contábeis não tinha o CNPJ eu fiz um merge com o operadoras_de_plano_de_saude_ativas que tinha a chave para conseguir o merge e trazia o CNPJ
  - **CNPJ/Razão Social:** Corrigidos casos de duplicidade gerados pela exclusão da coluna de contas contábeis.
  - **Datas inconsistentes** corrigidas via pandas
  - **ValorDespesas:**
      - ``` code
        - Se VL_SALDO_FINAL > VL_SALDO_INICIAL, então: VL_SALDO_FINAL - VL_SALDO_INICIAL.
        - Caso contrário: 0.
        ```

## 2. TESTE DE TRANSFORMAÇÃO E VALIDAÇÃO DE DADOS - 
- **OBJETIVO:** Valida os dados -> enrique-se com o merge -> agrupa e trás outras análises para os dados -> gera despesas_agregadas.csv e Teste_Gabriel.zip
- **CNPJ inválido:** Separados em um DataFrame à parte para evitar perda de dados e facilitar a análise.
- **Valores negativos:** Não existem mais (Tratados na etapa anterior) 
- **Razão social vazia:** Excluído
- **Match de Dados:** Nem todos os CNPJs do relatório existiam no consolidado dos últimos 3 trimestres. Então alguns CNPJ faltam certos dados.
- **CNPJs que aparecem múltiplas vezes no cadastro com dados diferentes**: Normal, pois Tem cnpj com razao duplicado apenas no Merge com o relatório, pois existem contas contabeis diferentes, que não foram trazidas para o df final
- **Estratégia de Join:** Utilizado Right Join no relatório para garantir a permanência de todos os registros possíveis baseados no CNPJ.
- **Ordenação:** Realizada ao final, após o agrupamento, para otimizar o processamento.

## 3. TESTE DE BANCO DE DADOS E ANÁLISE
- `ScriptsSQL/Creates`: Tem todos os scripts de criação e todas as tabelas e indexs
- Escolha e tabelas normalizadas:
  - **Dados Cadastrais:** Nome e endereço da operadora foram normalizados para garantir integridade e evitar repetição de strings longas em cada linha de despesa.
  - **Garantir a integridade do sistema**, pois é possivel mudar o nome, endereço... de uma operadora em apenas uma linha na tabela
  - Embora a Opção A (tabela única) facilite queries simples, o **PostgreSQL lida de forma extremamente eficiente com JOINs indexados por PK/FK**
  - **Valores Monetários:** Para dados financeiros, a precisão é inegociável, o que não é garantido com tipos FLOAT. Já o INTEGER exige que toda a lógica da aplicação e das queries trate as conversões, aumentando o risco de erros, enquanto o NUMERIC oferece a precisão necessária sem demandar lógicas complexas no backend.
  - **Datas:** DATE é utilizado para registros históricos e TIMESTAMP para auditoria. O tipo VARCHAR não permite o uso de funções temporais nativas, como EXTRACT. Entre DATE e TIMESTAMP, a escolha depende do nível de precisão necessário; como, neste caso, não há necessidade de precisão em segundos, optei pelo DATE.
  - Importação CSV -> SQL
    - Uso de tabelas temporárias (TEMP) para garantir a integridade dos dados
    - Entre na pasta do PostgreSQL
    - ```bash
        cd "C:\Program Files\PostgreSQL\{versao_banco}\bin"
      ```
    - Execute:
    - ```bash
        psql -U postgres -d {nome_do_banco} -f {Path}importando_csvs.sql
      ```
  - **Valores NULL em campos obrigatórios:** o registro é reijetado
  - **Strings em campos numéricos:** Para o campo valor_despesa, utilizaremos uma expressão regular para garantir que apenas números entrem.
  - **Datas em formatos inconsistentes:** Usei do to_date com tratamento de erro via CASE ou garantindo que o formato siga o padrão esperado.
  - Querys:
      - **Crescimento Percentual:** Operadoras que podem não ter dados em todos os trimestres -> Utilizando um INNER JOIN entre os subconjuntos do trimestre inicial e final, as operadoras que não possuem dados em ambos os períodos são desconsideradas do cálculo, pois não há uma base comparativa válida.
      - **Distribuição por UF e Médias:** Calcule também a média de despesas por operadora em cada UF -> Agrupando os dados por (operadora, uf)
      - **Operadoras Acima da Média em 2+ Trimestres:** CTEs (Common Table Expressions) com Agregação Condicional -> Melhor que múltiplas subqueries ou SELF JOINs porque percorre a tabela de despesas menos vezes.
   
## 4. TESTE DE API E INTERFACE WEB
Como executar:
- Backend
    - Na pasta raiz do projeto execute:
    - ```bash
        cd web/backend
        python -m uvicorn app.main:app --reload
      ```
    - Acesse o [swagger](http://127.0.0.1:8000/docs#/) 
- Frontend
  - Na pasta raiz do projeto execute:
    - ```bash
        cd web/backend
        npm run dev
      ```
    - Acesse o [Front](http://localhost:5173)
- Escolha do Framework: FastAPI -> maior familiaridade com o framework e suporte nativo a async/await, o que auxilia no processamento assíncrono de I/O e nas operações com o banco de dados.
- Estratégia de Paginação: Offset-based -> como a lista de operadoras possui apenas cerca de 1.100 registros, o impacto em relação a Cursor ou Keyset pagination é mínimo, além de oferecer maior simplicidade de implementação.
- Cache vs Queries Diretas: Pré-calcular e armazenar em tabela -> o volume de dados é elevado (~2 milhões de registros) e possui baixa frequência de atualização. Diante disso, pré-calcular e armazenar os resultados periodicamente garante consistência com menor custo computacional, já que as leituras diretas no dataset principal são reduzidas.
-  Estrutura de Resposta da API: apenas os dados não são suficientes para gerenciar componentes de UI como “Carregar mais” ou “Próxima página”. Portanto, é necessário incluir metadados como total, next_id, entre outros.


### Rotas de API e respostas:
Request
```url
http://127.0.0.1:8000/api/operadoras/?page=1&limit=3
```
Response
```json
{
  "items": [
    {
      "cnpj": "06814351000112",
      "razao_social": "CEDPLAN SAÚDE LTDA EPP",
      "nome_fantasia": null,
      "uf": "MG"
    },
    {
      "cnpj": "19541931000125",
      "razao_social": "18 DE JULHO ADMINISTRADORA DE BENEFÍCIOS LTDA",
      "nome_fantasia": null,
      "uf": "MG"
    },
    {
      "cnpj": "22869997000153",
      "razao_social": "2B ODONTOLOGIA OPERADORA DE PLANOS ODONTOLÓGICOS LTDA",
      "nome_fantasia": null,
      "uf": "SP"
    }
  ],
  "total": 1110,
  "next_id": "2"
}
```
---
Request
```url
http://127.0.0.1:8000/api/operadoras/06814351000112
```
Response
```json
{
  "cnpj": "06814351000112",
  "numero": "126",
  "telefone": "33396250",
  "complemento": "LOJA 16",
  "fax": null,
  "bairro": "CENTRO",
  "email": "regulacao@cedplan.com.br",
  "cidade": "Barbacena",
  "representante": "DAVID ALDRIN LOPES CARNEIRO",
  "uf": "MG",
  "cargo_representante": "SÓCIO-ADMINISTRADOR ",
  "modalidade": "Medicina de Grupo",
  "cep": "36200074",
  "regiao_comercializacao": 6,
  "nome_fantasia": null,
  "razao_social": "CEDPLAN SAÚDE LTDA EPP",
  "ddd": "32",
  "data_registro_ans": "2013-01-11",
  "registro_ans": "418749",
  "logradouro": "RUA QUINZE DE NOVEMBRO"
}
```
---
Request
```url
http://127.0.0.1:8000/api/operadoras/06814351000112/despesas
```
Response
```json
[
  {
    "ano": 2025,
    "trimestre": 3,
    "valor_despesa": "50781.75"
  },
  {
    "ano": 2025,
    "trimestre": 3,
    "valor_despesa": "0.00"
  },
  {
    "ano": 2025,
    "trimestre": 3,
    "valor_despesa": "0.00"
  },
...
]
```
---
Request
```url
http://127.0.0.1:8000/api/estatisticas
```
Response
```json
{
  "total_despesas": 3939875467248.42,
  "media_geral": 6804620841.534404,
  "top_5_operadoras": [
    {
      "razao_social": "BRADESCO SAÚDE S.A.",
      "total": 564862869098.75
    },
    {
      "razao_social": "AMIL ASSISTÊNCIA MÉDICA INTERNACIONAL S.A.",
      "total": 421916742513.39
    },
    {
      "razao_social": "HAPVIDA ASSISTENCIA MEDICA S.A.",
      "total": 250499397735.01
    },
    {
      "razao_social": "NOTRE DAME INTERMÉDICA SAÚDE S.A.",
      "total": 243791125393.24
    },
    {
      "razao_social": "UNIMED BELO HORIZONTE COOPERATIVA DE TRABALHO MÉDICO",
      "total": 121033581911.46
    }
  ]
}
```
