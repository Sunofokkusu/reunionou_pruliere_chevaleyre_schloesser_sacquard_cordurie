<template>
  <div>
    <h2>Inscription</h2>
    <q-input v-model="name" label="Nom*" name="name" required />
    <q-input v-model="email" label="Adresse mail*" name="email" required />
    <q-input
      v-model="password"
      label="Mot de passe*"
      name="password"
      required
    />
    <q-input
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
      @click="signin"
    />
    <div v-if="errored" class="error"><p>Veuillez remplir tous les champs.</p></div> 
  </div>
</template>

<script>
export default {
  name: "SignIn",
  data() {
    return {
      name: "",
      email: "",
      password: "",
      password_confirmed: "",
      errored: false,
    };
  },
  methods: {
    /**
     * Méthode qui permet de s'inscrire
     * @return, inutilisable
     */
    signin() {
      if (this.name !== "" && this.email !== "" && this.password !== "") {
        this.errored = false;
        this.axios.post("http://localhost:80/signin", {
          name: this.name,
          email: this.email,
          password: this.password,
        });
      } else {
        this.errored = true;
      }
    },
  }
};
</script>

<style scoped>
.confirm{
  margin-top: 1%;
  margin-bottom: 1%;
}
.error {
  color: red;
}
</style>
