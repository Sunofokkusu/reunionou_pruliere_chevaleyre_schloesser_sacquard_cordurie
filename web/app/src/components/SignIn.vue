<template>
  <div>
    <div class="container">
      <div class="signinCard">
        <h4>Connexion</h4>
        <q-input v-model="email" label="Adresse mail*" name="email" required />
        <q-input
          type="password"
          v-model="password"
          label="Mot de passe*"
          name="password"
          required
        />
        <q-btn
          class="confirm"
          color="primary"
          label="Connexion"
          @click="signin"
        />
        <div>Pas de compte ? <router-link to="signUp">inscription</router-link></div>
      </div> 
    </div>
    <div v-if="errored" class="error"><p>Veuillez remplir tous les champs.</p></div>
  </div>
</template>

<script>
export default {
  name: "SignIn",
  data() {
    return {
      email: "",
      password: "",
      errored: false,
    };
  },
  methods: {
    /**
     * Méthode qui permet de se connecter
     * @return, inutilisable
     */
    signin() {
      if (this.email !== "" && this.password !== "") {
        this.errored = false;
        this.axios.post("http://localhost:80/auth/signin", {
          email: this.email,
          password: this.password,
        }).then((response) => {
          this.$store.commit("setToken", response.data.token)
          this.$store.commit("setConnected", true)
          this.$router.push({ name: "HomePage" })
        });
      } else {
        this.errored = true;
      }
    },
  }
};
</script>

<style scoped>
.container {
  display: flex;
  justify-content: center;
}

.signinCard {
    cursor: pointer;
    text-align: center;
    border-radius: 10px;
    background-color: #fff;
    padding: 20px;
    margin: 8px;
    width: 300px;
    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
    transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s ,filter 0.1s;
}

.confirm{
  margin-top: 20px;
  margin-bottom: 20px;
}

.error {
  color: red;
  text-align: center;
}
</style>
