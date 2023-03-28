<template>
  <div>
    <button @click="getUser">ICIICICICICICI</button>
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
  methods: {
    getUser() {
      this.axios
        .get("http://localhost:80/user/me", {
        })
        .then((response) => {
          console.log(response);
        });
      return null;
    },
  },
};
</script>

<style scoped></style>
