<template>
  <div>
    <div class="container">
      <div class="signinCard">
        <h4>Connexion</h4>
        <q-input color="green" v-model="email" label="Adresse mail*" name="email" required />
        <q-input
          color="green"
          type="password"
          v-model="password"
          label="Mot de passe*"
          name="password"
          required
        />
        <q-btn
          color="green"
          class="confirm"
          label="Connexion"
          @click="signin"
        />
        <div>Pas de compte ? <router-link to="signUp">inscription</router-link></div>
      </div> 
    </div>
    <div v-if="errored" class="error"><p>Veuillez remplir tous les champs.</p></div>
    <div v-if="errorSignIn" class="error"><p>{{ errorMsg }}</p></div>
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
      errorSignIn: false,
      errorMsg: ""
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
        this.errorSignIn = false;
        this.errorMsg = ""
        this.axios.post(this.$store.state.base_url + "/auth/signin", {
          email: this.email,
          password: this.password,
        })
        .then((response) => {
          this.$store.commit("setToken", response.data.token)
          this.$store.commit("setConnected", true)
          this.axios.defaults.headers.get['Authorization'] = this.$store.state.token;
          this.axios.get(this.$store.state.base_url + "/user/me")
            .then((response) => {
              this.$store.commit("setName", response.data.name)
              this.$router.push({ name: "HomePage" })
              }
            ).catch((error) => {
              console.log(error)
            })
        })
        .catch((error) => {
          this.errorMsg = error.response.data.message;
          this.errorSignIn = true;
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
