<template>
  <div class="operadoras-container">
    <h2>Lista de Operadoras</h2>
    
    <div v-if="operadoras.length === 0">Nenhuma operadora encontrada.</div>
    
    <ul v-else class="operadoras-list">
      <li v-for="op in operadoras" :key="op.cnpj" class="operadora-item">
        <div class="operadora-info">
          <strong>{{ op.razao_social }}</strong>
          <p>CNPJ: {{ op.cnpj }}</p>
        </div>
        <button @click="verDetalhes(op.cnpj)" class="btn-detalhes">Ver Detalhes</button>
      </li>
    </ul>
    
    <div class="pagination">
      <button @click="mudarPagina(currentPage - 1)" :disabled="currentPage === 1" class="btn-pagina">Anterior</button>
      <span>Página {{ currentPage }}</span>
      <button @click="mudarPagina(currentPage + 1)" class="btn-pagina">Próxima</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, defineEmits } from 'vue'; // Importe o defineEmits
import { apiService } from '../api/apiService';

// Define quais "mensagens" este componente envia para o App.vue
const emit = defineEmits(['selecionar']);

const operadoras = ref([]);
const currentPage = ref(1);

const carregarDados = async (page) => {
  try {
    const response = await apiService.getOperadoras(page);
    operadoras.value = response.data.items;
    currentPage.value = page;
  } catch (error) {
    console.error("Erro ao carregar dados:", error);
  }
};

const mudarPagina = (novaPagina) => carregarDados(novaPagina);

// Agora enviamos o CNPJ para o App.vue
const verDetalhes = (cnpj) => {
  emit('selecionar', cnpj);
};

onMounted(() => carregarDados(1));
</script>

<style scoped>
.operadoras-container { padding: 20px; }
.operadoras-list { list-style: none; padding: 0; }
.operadora-item { display: flex; justify-content: space-between; align-items: center; padding: 10px; border: 1px solid #ccc; margin-bottom: 10px; border-radius: 8px; }
.operadora-info { flex: 1; }
.btn-detalhes { padding: 8px 12px; background: #007bff; color: white; border: none; cursor: pointer; border-radius: 4px; }
.btn-detalhes:hover { background: #0056b3; }
.pagination { margin-top: 20px; text-align: center; }
.btn-pagina { padding: 8px 12px; margin: 0 10px; background: #444; color: white; border: none; cursor: pointer; border-radius: 4px; }
.btn-pagina:disabled { background: #ccc; cursor: not-allowed; }
</style>