<template>
  <div class="ai-center-container">
    <nav-bar></nav-bar>
    <div class="ai-dashboard">
      <div class="dashboard-row">
        <CodeQualityCard class="dashboard-card" />
        <LanguagePreferenceCard class="dashboard-card" />
      </div>
      <div class="dashboard-row">
        <AIInteractionCard class="dashboard-card" />
        <ProblemSolvingPathCard class="dashboard-card" />
      </div>
    </div>
  </div>
</template>

<script>
import CodeQualityCard from './components/CodeQualityCard.vue';
import LanguagePreferenceCard from './components/LanguagePreferenceCard.vue';
import AIInteractionCard from './components/AIInteractionCard.vue';
import ProblemSolvingPathCard from './components/ProblemSolvingPathCard.vue';
import NavBar from '@/components/NavBar.vue';

export default {
  name: 'AICenter',
  components: {
    CodeQualityCard,
    LanguagePreferenceCard,
    AIInteractionCard,
    ProblemSolvingPathCard,
    NavBar
  }
}
</script>

<style scoped>
.ai-center-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #0d1117;
  color: white;
  overflow-x: hidden;
}

.ai-dashboard {
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding: 30px 50px;
  width: 100%;
  max-width: 1600px;
  margin: 0 auto;
  flex-grow: 1;
}

.dashboard-row {
  display: flex;
  gap: 24px;
  width: 100%;
  min-height: calc(50vh - 120px);
}

.dashboard-card {
  flex: 1;
  min-height: 100%;
  background-color: #1e1e2e;
  border-radius: 10px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
  padding: 24px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  display: flex;
  flex-direction: column;
}

.dashboard-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.4);
}

@media (max-width: 1200px) {
  .ai-dashboard {
    padding: 20px 30px;
  }
}

@media (max-width: 768px) {
  .dashboard-row {
    flex-direction: column;
    min-height: auto;
  }
  
  .dashboard-card {
    min-height: 450px;
  }
  
  .ai-dashboard {
    padding: 15px;
  }
}
</style> 