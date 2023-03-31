<template>
  <div class="center">
    <div class="row">
      <div class="card col-3">
        <div v-if="eventLoading">
          <SpinnerComp> Récupération de l'événement en cours... </SpinnerComp>
        </div>
        <div v-if="eventError">
          Erreur lors de la récupération de l'événement
        </div>
        <div v-else>
          <div v-if="getEventComputed.title">
            <h4>{{ getEventComputed.title }}</h4>
            <p>Créé par: {{ getEventComputed.creator.name }}</p>
            <p>Description: {{ getEventComputed.description }}</p>
            <p>
              Date de rendez-vous:
              {{ new Date(getEventComputed.date).toLocaleDateString() }}
            </p>
            <p>
              Heure de rendez-vous:
              {{ new Date(getEventComputed.date).getHours() - 2 }}h{{
                new Date(getEventComputed.date).getMinutes()
              }}
            </p>
            <p>Lieu de rendez vous: {{ getEventComputed.adress }}</p>
          </div>
        </div>
      </div>

      <div class="card col-3">
        <p class="history-title">Participants</p>
        <div class="history">
          <div v-for="part in participants" :key="part.name">
            <p>
              <strong>{{ part.name }}</strong> &nbsp;<span
                v-if="part.status === 1"
                >viens</span
              >
              <span v-if="part.status === 2">ne viens pas</span>
              &nbsp;<span v-if="part.message !== undefined"
                >(<i>{{ part.message.toLowerCase() }}</i
                >)</span
              >
            </p>
          </div>
        </div>
        <div class="center">
          <div class="row" v-if="button">
            <q-btn
              color="primary"
              class="col-5"
              @click="
                join = true;
                choice = true;
              "
              >Je viens</q-btn
            >
            &emsp;
            <q-btn
              color="deep-orange"
              class="col-5"
              @click="
                join = true;
                choice = false;
              "
              >Désolé</q-btn
            >
          </div>
        </div>
      </div>

      <div class="card col-3">
        <div v-if="meteoLoading">
          <SpinnerComp> Recherche de prévisions météo en cours... </SpinnerComp>
        </div>
        <div v-if="meteoError">
          Erreur lors de la recherche de prévisions météo
        </div>
        <div v-else>
          <div v-if="meteo">
            <p>ville: {{ meteo.city.name }}</p>
            <p>tendance: {{ meteo.list[0].weather[0].description }}</p>
            <p>
              température:
              {{ (meteo.list[0].main.temp - 273.15).toFixed(2) }}°C
            </p>
            <p>pression: {{ meteo.list[0].main.pressure }} hPa</p>
            <p>humidité: {{ meteo.list[0].main.humidity }} %</p>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div style="height: 300px; max-width: 616px" class="card map col-6">
        <l-map ref="map" :zoom="zoom" :center="[lat, long]">
          <l-tile-layer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            layer-type="base"
            name="OpenStreetMap"
          ></l-tile-layer>
          <l-marker :lat-lng="markerLatLng" ></l-marker>
        </l-map>
      </div>

      <div class="col-4 card">
        <div class="history_comments">
          <div v-for="com in comments" :key="com.id">
            <p>
              <strong>{{ com.name }}</strong
              >: {{ com.comment }}
            </p>
          </div>
        </div>
        <div class="inputBox">
          <div>
            <q-input
              filled
              v-model="comment"
              dense
              label="Commentaire"
              autofocus
            >
              <template v-slot:after>
                <q-btn flat @Click="addcomment">
                  <i class="fas fa-paper-plane"></i>
                </q-btn>
              </template>
            </q-input>
          </div>
        </div>
      </div>
    </div>

    <q-dialog v-model="comment_logoff" persistent>
      <q-card class="modal">
        <q-card-section class="row items-center">
          <div class="q-ml-sm">
            <q-input v-model="name" label="Nom" />
          </div>
        </q-card-section>

        <q-btn
          flat
          label="Valider"
          color="primary"
          v-close-popup
          @Click="addcommentlogoff"
        />

        <q-btn
          flat
          label="Annuler"
          color="negative"
          v-close-popup
          @Click="reset"
        />

        <q-card-section v-if="errored" class="items-center">
          <div class="q-ml-sm red">
            Veuillez renseigner tous les champs obligatoires
          </div>
        </q-card-section>
      </q-card>
    </q-dialog>

    <q-dialog v-model="join" persistent>
      <q-card class="modal">
        <q-card-section class="row items-center">
          <div class="q-ml-sm">
            <q-input
              v-if="this.$store.state.token === ''"
              v-model="name"
              label="Nom"
              autofocus
            />
            <q-input v-model="message" label="Message (optionnel)" />
          </div>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn
            flat
            label="Annuler"
            color="negative"
            v-close-popup
            @Click="reset"
          />
          <q-btn
            flat
            label="Ajouter"
            color="primary"
            v-close-popup
            @Click="addParticipant"
          />
        </q-card-actions>

        <q-card-section v-if="errored" class="items-center">
          <div class="q-ml-sm red">
            Veuillez renseigner tous les champs obligatoires
          </div>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import "leaflet/dist/leaflet.css";
import { LMap, LTileLayer, LMarker } from "@vue-leaflet/vue-leaflet";
import SpinnerComp from "@/components/Spinner.vue";
export default {
  name: "EventPage",
  components: {
    LMap,
    LTileLayer,
    LMarker,
    SpinnerComp,
  },
  data() {
    return {
      event: "",
      zoom: 10,
      participants: [],
      join: false,
      name: "",
      message: "",
      choice: false,
      status: 0,
      meteo: "",
      meteoLoading: true,
      meteoError: false,
      eventLoading: true,
      eventError: false,
      button: true,
      user: "",
      comments: "",
      comment: "",
      comment_logoff: false,
      addComment: "",
      markerLatLng:[],
      lat: "",
      long: ""
    };
  },
  async mounted() {
    await this.getEvent();
    //permet de récupérer les données météo de la ville de l'événement
    try {
      let response = await fetch(
        "http://api.openweathermap.org/data/2.5/forecast?appid=fb5491e240ff2f7ced5a60bd2e08e545&lat=" +
          this.event.lat + "&lon=" + this.event.long +
          "&lang=fr"
      );
      let json = await response.json();
      this.meteo = json;
      this.meteoLoading = false;
    } catch (error) {
      this.meteoLoading = false;
      console.log(error);
      this.meteoError = true;
    }

    //permet d'afficher un point sur la carte en fonction de l'adresse 
    this.markerLatLng.push(this.event.lat)
    this.markerLatLng.push(this.event.long)
    this.lat = this.event.lat
    this.long = this.event.long

    //permet de désactiver les boutons si l'utilisateur est déjà inscrit à l'événement
    if (this.$store.state.token !== "") {
      try {
        let response = await this.axios.get(
          this.$store.state.base_url + "/user/me?embed=all",
          {}
        );
        this.user = response.data;
        this.user.events.forEach((e) => {
          if (e.id === this.$route.params.event_id) {
            this.button = false;
          }
        });
      } catch (error) {
        console.log(error);
      }
    }
  },
  computed: {
    /**
     * récupère l'événement
     * @returns {Object} l'événement
     */
    getEventComputed() {
      this.getEvent();
      return this.event;
    },
  },
  methods: {
    /**
     * récupère l'événement et le stocke dans la variable event
     * @return inutilisable
     */
    async getEvent() {
      try {
        let response = await this.axios.get(
          this.$store.state.base_url + "/event/" + this.$route.params.event_id
        );
        this.event = response.data;
        this.participants = response.data.participants;
        this.comments = response.data.comments;
        this.eventLoading = false;
        this.eventError = false;
      } catch (error) {
        console.log(error);
        this.eventLoading = false;
        this.eventError = true;
      }
    },

    /**
     * ajoute un participant à l'évènement
     * @return inutilisable
     */
    addParticipant() {
      if (this.choice === false) {
        this.status = 2;
      } else {
        this.status = 1;
      }
      if (this.$store.state.token === "") {
        this.axios.post(
          this.$store.state.base_url +
            "/event/" +
            this.$route.params.event_id +
            "/participant",
          {
            name: this.name,
            status: this.status,
            message: this.message,
          }
        );
      } else {
        this.axios.defaults.headers.post["Authorization"] =
          this.$store.state.token;
        this.axios.post(
          this.$store.state.base_url +
            "/event/" +
            this.$route.params.event_id +
            "/participant",
          {
            status: this.status,
            message: this.message,
          }
        );
      }
      this.reset();
      this.button = false;
    },

    /**
     * réinitialise les champs
     * @return inutilisable
     */
    reset() {
      this.name = "";
      this.message = "";
      this.comment = "";
    },
    /**
     * Ajoute un commentaire si l'utilisateur est connecté, ouvre le pop-up de nom sinon
     * @return inutilisable
     */
    async addcomment() {
      if (this.$store.state.token === "") {
        this.comment_logoff = true;
      } else {
        try {
          this.axios.defaults.headers.post["Authorization"] =
            this.$store.state.token;
          this.axios.post(
            this.$store.state.base_url +
              "/event/" +
              this.$route.params.event_id +
              "/comment",
            {
              message: this.comment,
            }
          );
          this.reset();
        } catch (error) {
          console.log(error);
        }
      }
    },
    /**
     * Ajoute un commentaire si l'utilisateur n'est pas connecté
     * @return inutilisable
     */
    async addcommentlogoff() {
      try {
        this.axios.post(
          this.$store.state.base_url +
            "/event/" +
            this.$route.params.event_id +
            "/comment",
          {
            name: this.name,
            message: this.comment,
          }
        );
        this.reset();
      } catch (error) {
        console.log(error);
      }
    },
  },
};
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
.center > div {
  display: flex;
  align-items: center;
  justify-content: center;
}
h4 {
  margin-bottom: 20px;
  margin-top: 20px;
}

.history {
  overflow-y: scroll;
  height: 200px !important;
  background-color: #e5e5e5;
  border-radius: 10px;
  margin-bottom: 10px;
}
.history > div > p {
  margin-bottom: -4px;
  margin-top: 5px;
  border-bottom: solid 1px #000000;
}
.history_comments {
  overflow-y: scroll;
  height: 234px !important;
  background-color: #e5e5e5;
  border-radius: 10px;
}
.history_comments > div > p {
  margin-bottom: -4px;
  margin-top: 5px;
  border-bottom: solid 1px #000000;
}
.history-title {
  margin-bottom: 5px;
}
.inputBox {
  width: 100%;
  margin-top: 5px;
}
</style>
