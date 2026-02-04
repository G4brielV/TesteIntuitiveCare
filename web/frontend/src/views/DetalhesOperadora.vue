<template>
  <div class="detalhes-container">
    <button @click="$emit('voltar')">← Voltar para Lista</button>
    
    <div v-if="loading">Carregando detalhes...</div>
    
    <div v-else-if="operadora">
      <h2>{{ operadora.razao_social }}</h2>
      <div class="info-grid">
        <p><strong>CNPJ:</strong> {{ operadora.cnpj }}</p>
        <p><strong>Registro ANS:</strong> {{ operadora.registro_ans }}</p>
        <p><strong>Cidade/UF:</strong> {{ operadora.cidade }} / {{ operadora.uf }}</p>
        <p><strong>E-mail:</strong> {{ operadora.email }}</p>
      </div>

      <h3>Histórico de Despesas</h3>
      <table class="styled-table">
        <thead>
          <tr>
            <th>Ano</th>
            <th>Trimestre</th>
            <th>Valor da Despesa</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(d, index) in despesas" :key="index">
            <td>{{ d.ano }}</td>
            <td>{{ d.trimestre }}º</td>
            <td>R$ {{ d.valor_despesa.toLocaleString('pt-BR') }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { apiService } from '../api/apiService';

const props = defineProps(['cnpj']);
const operadora = ref(null);
const despesas = ref([]);
const loading = ref(true);

onMounted(async () => {
  try {
    const [resDet, resDesp] = await Promise.all([
      apiService.getOperadoraDetalhes(props.cnpj),
      apiService.getHistoricoDespesas(props.cnpj)
    ]);
    operadora.value = resDet.data;
    despesas.value = resDesp.data;
  } catch (error) {
    console.error("Erro ao buscar detalhes:", error);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 20px; background: #222; padding: 15px; border-radius: 8px; }
.styled-table { width: 100%; border-collapse: collapse; }
.styled-table th, .styled-table td { padding: 10px; border: 1px solid #444; text-align: left; }
button { margin-bottom: 20px; padding: 10px; cursor: pointer; background: #444; color: white; border: none; }
</style>