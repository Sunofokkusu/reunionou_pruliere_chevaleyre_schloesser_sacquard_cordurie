<template>
  <div>
      <div class="container">
        <div v-if="profileLoading" class="card profileCard">
          <Spinner-comp class="spinner">
            <p>Chargement du profil...</p>
          </Spinner-comp>
        </div>
        <div v-else-if="profileError" class="card profileCard">
          <p>Erreur lors du chargement du profil</p>
        </div>
        <div v-else class="card profileCard">
          <div v-if="user">
            <h4>{{ user.name }}</h4>
            <p>Adresse mail: {{ user.mail }}</p>
          </div>
        </div>
      </div>

      <div class="card">
        <p>Évènements créés</p>
        <div class="row  col-8">
          <div v-if="profileLoading" class="card eventCard col-2">
            <Spinner-comp>
            </Spinner-comp>
          </div>
          <div v-if="profileError" class="card eventCard col-2">
            <p>Erreur lors du chargement des évènements</p>
          </div>
          <div v-else v-for="event in user.events" :key="event.id" class="card eventCard col-2" @click="this.$router.push({ name: 'Event', params: { event_id: event.id } })">
            <button class="delete" @click.stop="">❌</button>
            <p>{{ event.title }}</p>
            <p>{{ event.description }}</p>
            <p>{{ new Date(event.date).toLocaleDateString() }}</p>
            <p>{{ new Date(event.date).getHours()-2 }}h{{ new Date(event.date).getMinutes() }}</p>
            <p>{{ event.adress }}</p>
          </div>
        </div>
      </div>

  </div>
</template>

<script>
import SpinnerComp from "./Spinner.vue";
export default {
  name: "ProfileUser",
  components: {
    SpinnerComp,
  },
  data() {
    return {
      user: "",
      profileLoading: true,
      profileError: false,
    };
  },
  /**
   * Permet de récupérer toutes les informations sur l'utilisateur connecté au chargement de la page 
   * en les passant dans la data du component
   * @return, inutilisable
   */
  async mounted() {
    try {
      this.axios.defaults.headers.get['Authorization'] = this.$store.state.token;
      let response = await this.axios.get(this.$store.state.base_url + "/user/me?embed=events", {})
      this.user = response.data;
      this.profileLoading = false;
      this.profileError = false; 
    } catch (error) {
      console.log(error);
      this.profileError = true;
      this.profileLoading = false;
    }
      
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
  height: 200px;
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

.spinner {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100%;
}
.spinner>p {
    margin-bottom: -20px;
}
</style>
