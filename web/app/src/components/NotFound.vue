<template>
<div class="notfound">
    <div >
        <h2>Page inexistante</h2>
        <h2>404</h2>
    </div>
    <router-link to="/">retour à la page d'accueil</router-link>
</div>
</template>

<script>
export default {
  name: "NotFound"
}
</script>

<style scoped>
.notfound {
    text-align: center;
}
</style>