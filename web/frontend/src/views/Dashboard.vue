<template>
  <div class="container">
    <h2>Estatísticas Gerais</h2>
    
    <div v-if="loading">Carregando dados...</div>
    
    <div v-else class="stats-grid">
      <div class="card">
        <p>Total de Despesas</p>
        <strong>R$ {{ stats.total_despesas.toLocaleString('pt-BR') }}</strong>
      </div>
      <div class="card">
        <p>Média Geral</p>
        <strong>R$ {{ stats.media_geral.toLocaleString('pt-BR') }}</strong>
      </div>
      
      <!-- Nova seção para Top 5 Operadoras -->
      <div class="card top-5-card">
        <p>Top 5 Operadoras por Despesas</p>
        <ul class="top-5-list">
          <li v-for="(op, index) in stats.top_5_operadoras" :key="index">
            <span>{{ index + 1 }}. {{ op.razao_social }}</span>
            <strong>R$ {{ op.total.toLocaleString('pt-BR') }}</strong>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { apiService } from '../api/apiService';

// Estados reativos (adicionando top_5_operadoras)
const stats = ref({ total_despesas: 0, media_geral: 0, top_5_operadoras: [] });
const loading = ref(true);

// Função executada ao montar o componente (similar ao @PostConstruct)
onMounted(async () => {
  try {
    const response = await apiService.getEstatisticasGerais();
    stats.value = response.data;
  } catch (error) {
    console.error("Erro ao buscar estatísticas:", error);
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
.stats-grid { display: flex; flex-wrap: wrap; gap: 20px; }
.card { border: 1px solid #ccc; padding: 20px; border-radius: 8px; flex: 1; min-width: 200px; }
.top-5-card { flex: 2; } /* Faz a seção do top 5 ocupar mais espaço */
.top-5-list { list-style: none; padding: 0; }
.top-5-list li { display: flex; justify-content: space-between; margin-bottom: 10px; }
</style>