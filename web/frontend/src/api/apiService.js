import axios from 'axios';

const api = axios.create({
  baseURL: 'http://127.0.0.1:8000/api', // URL do seu FastAPI
  headers: {
    'Content-Type': 'application/json'
  }
});

export const apiService = {
  // GET /api/operadoras?page=1&limit=20
  getOperadoras(page = 1, limit = 20) {
    return api.get(`/operadoras`, {
      params: { page, limit }
    });
  },

  // GET /api/operadoras/{cnpj}
  getOperadoraDetalhes(cnpj) {
    return api.get(`/operadoras/${cnpj}`);
  },

  // GET /api/operadoras/{cnpj}/despesas
  getHistoricoDespesas(cnpj) {
    return api.get(`/operadoras/${cnpj}/despesas`);
  },

  // GET /api/estatisticas
  getEstatisticasGerais() {
    return api.get('/estatisticas');
  }
};