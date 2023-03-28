<template>
  <div>
      <div class="container">
        <div class="card profileCard">
          <p><strong>{{ user.name }}</strong></p>
          <p>Adresse mail: {{ user.mail }}</p>
        </div>
      </div>
      <div class="card">
        <p>Évènements créés</p>
        <div class="row  col-8">
          <div v-for="event in user.events" :key="event.id" class="card eventCard col-2">
            <button class="delete" @click.stop="">❌</button>
            <p>{{ event.title }}</p>
            <p>{{ event.description }}</p>
            <p>{{ new Date(event.date).toLocaleDateString() }}</p>
            <p>{{ new Date(event.date).getHours() }}h{{ new Date(event.date).getMinutes() }}</p>
            <p>{{ event.adress }}</p>
          </div>
        </div>
      </div>

  </div>
</template>

<script>
export default {
  name: "ProfileUser",
  data() {
    return {
      user: "",
    };
  },
  mounted() {
      this.axios.defaults.headers.get['Authorization'] = this.$store.state.token;
      this.axios
        .get("http://localhost:80/user/me?embed=events", {})
        .then((response) => {
          this.user = response.data;
        });
      return null;
  },
};
</script>

<style scoped>
.container {
  width: 100%;
  display: flex;
  justify-content: center;
}
.card {
    text-align: center;
    border-radius: 10px;
    background-color: #fff;
    padding: 8px;
    margin: 8px;
    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
}
.card>p:first-of-type {
    margin-top: 15px;
    font-size: 1.5em;
}
.profileCard {
  max-width: 400px !important;
  padding: 20px;
}
.eventCard {
    cursor: pointer;
    padding:0;
    margin: 8px;
    width: 200px !important;
    height: 200px !important;
    transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s ,filter 0.1s;
}
.eventCard>p {
    margin-top: -10px;
}
.eventCard {
    background-color: #ecebeb;
}
.eventCard:hover {
    width: 207px !important;
    height: 207px !important;
    margin: 5px;
    filter: brightness(96%) ;
}
.eventCard:active {
    filter: brightness(90%);
}
.eventCard>p:first-of-type {
    margin-top: 30px;
    font-size: 1.5em;
}

.delete {
    background-color: transparent;
    border: none;
    cursor: pointer;
    filter: hue-rotate(226deg) brightness(120%);
    margin-left: -70px;
    margin-top: 10px;
    float: right;
}
.delete:hover {
    filter: hue-rotate(1deg);
}
</style>
