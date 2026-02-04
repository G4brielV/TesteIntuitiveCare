# Projeto IntuitiveCare

Este projeto consiste em um pipeline de processamento de dados para extrair e analisar despesas de operadoras de saúde da ANS (Agência Nacional de Saúde Suplementar), seguido de uma aplicação web para visualização dos dados.

## 📁 Estrutura do Projeto

- `integracao.ipynb`: Notebook para integração e download de dados da ANS.
- `transformacao.ipynb`: Notebook para transformação e validação dos dados.
- `web/backend/`: API backend desenvolvida em FastAPI (Python).
- `web/frontend/`: Interface frontend desenvolvida em Vue.js.
- `downloads/`: Pasta contendo os dados baixados e processados.
- `despesas_agregadas.csv`: Arquivo CSV com os dados consolidados e agregados.
- `Relatorio_cadop.csv`: Relatório de operadoras ativas.

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
git clone <url-do-repositorio>
cd projeto-intuitivecare
``` 

### Dependências do Python
Crie um arquivo requirements.txt na raiz do projeto (caso não exista) com o conteúdo necessário (FastAPI, SQLAlchemy, Pandas, etc.) e instale:

```bash
pip install -r requirements.txt
``` 

### Dependências do Node.js
Navegue para a pasta do frontend e instale as dependências:
```bash
cd web/frontend
npm install
``` 
As principais dependências instaladas são:

Vue.js
Axios (comunicação com a API)
Vite (tooling de desenvolvimento)