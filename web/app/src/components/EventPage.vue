<template>
  <div class="center">
    <div class="row">
      <div class="card col-3">
        <h4>{{ getEventComputed.title }}</h4>
        <p>Description: {{ getEventComputed.description }}</p>
        <p>Date de rendez-vous: {{ new Date(getEventComputed.date).toLocaleDateString() }}</p>
        <p>Heure de rendez-vous: {{ new Date(getEventComputed.date).getHours()-2 }}h{{ new Date(getEventComputed.date).getMinutes() }}</p>
        <p>Lieu de rendez vous: {{ getEventComputed.adress }}</p>
      </div>

      <div class="card col-3 ">
        <p class="history-title">Participants</p>
        <div class="history">
          <div>
            <p>Prénom </p>
          </div>
        </div>
        <div class="center">
          <div class="row">
            <q-btn color="primary" class="col-5">Je viens</q-btn>
            &emsp;
            <q-btn color="deep-orange" class="col-5">Désolé</q-btn>
          </div>
        </div>            
      </div>

      <div class="card col-3">
        meteo
      </div>
    </div>

    <div class="row">

      <div style="height:300px; max-width:616px" class="card map col-6">
        <l-map ref="map" :zoom="zoom" :center="[48.69, 6.18]">
          <l-tile-layer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            layer-type="base"
            name="OpenStreetMap"
          ></l-tile-layer>
        </l-map>
      </div>

      <div class="col-4 card">

      </div>

    </div>
   
  </div>
</template>

<script>
import "leaflet/dist/leaflet.css";
import { LMap, LTileLayer } from "@vue-leaflet/vue-leaflet";

export default {
  name: "EventPage",
    components: {
    LMap,
    LTileLayer,
  },
  data() {
    return {
      event: "",
      zoom: 10,
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
        let response = await this.axios.get("http://localhost:80/event/" + this.$route.params.event_id);
        this.event = response.data;
      } catch (error) {
        console.log(error);
      }
    },
  },
}
</script>

<style scoped>
.card {
    border-radius: 10px;
    background-color: #fff;
    padding: 10px;
    margin: 8px;
    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
    font-size: 1.2em;
    text-align: center;
    min-width: 300px !important;
    min-height: 300px !important;
    overflow: hidden;
    text-overflow: ellipsis;
}

.map { 
  padding: 0;
}

.center {
    width: 100%;
    height: 100%;
    text-align: center;
}
.center>div {
    display: flex;
    align-items: center;
    justify-content: center;
}
h4 {
    margin-bottom: 20px;
    margin-top: 20px;
}

.history {
    padding-top: 10px;
    overflow-y: scroll;
    height: 200px !important;
    background-color: #e5e5e5;
    border-radius: 10px;
    margin-bottom: 10px;
}
.history>div>p:nth-child(1) {
    margin-bottom: -4px;
    margin-top: -10px;
}
.history>div>p:nth-child(1) {
    border-bottom: solid 1px #000000;
}
.history-title {
    margin-bottom: 5px;
}
</style>
