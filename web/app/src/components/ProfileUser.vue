<template>
  <div>
    <div class="container">
      {{ user.name }}
      {{ user.mail }}
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

<style scoped></style>
