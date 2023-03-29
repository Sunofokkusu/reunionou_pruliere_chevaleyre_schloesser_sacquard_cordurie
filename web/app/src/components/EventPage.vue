<template>
  <div class="container">
    <div class="card eventCard">
      <p><strong>{{ getEventComputed.title }}</strong></p>
      <p>Description: {{ getEventComputed.description }}</p>
      <p>Date de rendez-vous: {{ new Date(getEventComputed.date).toLocaleDateString() }}</p>
      <p>Heure de rendez-vous: {{ new Date(getEventComputed.date).getHours()-2 }}h{{ new Date(getEventComputed.date).getMinutes() }}</p>
      <p>Lieu de rendez vous: {{ getEventComputed.adress }}</p>
    </div>
    <div class="card">

    </div>
  </div>
</template>

<script>
export default {
  name: "EventPage",
  data() {
    return {
      event: "",
    };
  },
  computed: {
    getEventComputed() {
      this.getEvent();
      return this.event
    }
  },
  methods: {
    async getEvent() {
      try {
        let response = await this.axios.get("http://localhost:80/event/" + this.$route.params.id);
        this.event = response.data;
      } catch (error) {
        console.log(error);
      }
    },
  },
}
</script>
