<template>
  <div>
    <div class="container">
      <div class="signinCard">
        <h4>Inscription</h4>
        <q-input v-model="name" label="Nom*" name="name" required />
        <q-input v-model="email" label="Adresse mail*" name="email" required />
        <q-input
          type="password"
          v-model="password"
          label="Mot de passe*"
          name="password"
          required
        />
        <q-input
          type="password"
          v-model="password_confirmed"
          label="Confirmer le mot de passe*"
          name="password_confirmed"
          required
        />
        <q-btn
          class="confirm"
          color="primary"
          label="Inscription"
          :disable="password !== password_confirmed"
          @click="signup"
        />
        <div>Dejà un compte ? <router-link to="signIn">connexion</router-link></div>
      </div>
    </div>
    <div v-if="errored" class="error"><p>Veuillez remplir tous les champs.</p></div>
    <div v-if="errorSignUp" class="error"><p>{{errorMsg}}</p></div>
  </div>
</template>

<script>
export default {
  name: "SignUp",
  data() {
    return {
      name: "",
      email: "",
      password: "",
      password_confirmed: "",
      errored: false,
      errorSignUp: false,
      errorMsg: ""
    };
  },
  methods: {
    /**
     * Méthode qui permet de s'inscrire
     * @return, inutilisable
     */
    signup() {
      if (this.name !== "" && this.email !== "" && this.password !== "") {
        this.errored = false;
        this.errorSignUp = false;
        this.errorMsg = "";
        this.axios.post(this.$store.state.base_url + "/auth/signup", {
          "name": this.name,
          "email": this.email,
          "password": this.password,
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
          this.errorSignUp = true;
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
