<script setup>
import { ref } from 'vue';
import Dashboard from './views/Dashboard.vue';
import Operadoras from './views/Operadoras.vue';
import DetalhesOperadora from './views/DetalhesOperadora.vue';

const telaAtual = ref('dashboard');
const cnpjSelecionado = ref(null);

const abrirDetalhes = (cnpj) => {
  cnpjSelecionado.value = cnpj;
  telaAtual.value = 'detalhes';
};
</script>

<template>
  <div class="layout">
    <nav class="sidebar">
      <h2>Menu</h2>
      <button @click="telaAtual = 'dashboard'">Dashboard</button>
      <button @click="telaAtual = 'operadoras'">Operadoras</button>
    </nav>

    <main class="main-content">
      <Dashboard v-if="telaAtual === 'dashboard'" />
      
      <Operadoras 
        v-if="telaAtual === 'operadoras'" 
        @selecionar="abrirDetalhes" 
      />
      
      <DetalhesOperadora 
        v-if="telaAtual === 'detalhes'" 
        :cnpj="cnpjSelecionado" 
        @voltar="telaAtual = 'operadoras'" 
      />
    </main>
  </div>
</template>