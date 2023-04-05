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
            <div v-if="editUser" class="edit">
              <i v-if="edit" class="fas fa-trash" @click="edit = false"></i>
              <i v-else class="fas fa-pen" @click="edit = true"></i>
            </div>
            <q-input color="green" class="editInput" v-if="edit" v-model="editTitle" filled dense placeholder="nouveau titre"></q-input>
            <h4 v-else>{{ getEventComputed.title }}</h4>
            <q-input color="green" class="editInput" v-if="edit" v-model="editDate" filled dense type="date"></q-input>
            <q-input color="green" class="editInput" v-if="edit" v-model="editTime" filled dense type="time"></q-input>
            <q-input color="green" class="editInput" v-if="edit" v-model="editDescr" filled dense placeholder="nouvelle description"></q-input>
            <div v-else>
              <p> le {{ new Date(getEventComputed.date.substr(0, 10)).toLocaleDateString() }} à {{ getEventComputed.date.substr(11, 5) }}</p>
              <p >Organisé par: {{ getEventComputed.creator.name }}</p>
              <p >Description: {{ getEventComputed.description }}</p>
            </div>          
            <q-input color="green" class="editInput" v-if="edit" v-model="editAdress" filled dense></q-input>
            <q-btn v-if="edit" color="green" @Click="editEvent">
              Modifier&emsp;<i class="fas fa-check"></i>
            </q-btn>
            <div v-else>
              <p>Lieu de rendez vous: {{ getEventComputed.adress }}</p>
              <q-btn color="primary" @click="changeTooltip">Partager&nbsp;&ensp;<i class="fas fa-link"></i>
                <q-tooltip anchor="center right" self="center left" :offset="[5, 5]">
                  {{tooltip}}
                </q-tooltip>
              </q-btn>
            </div>
          </div>
        </div>
      </div>

      <div class="card col-3">
        <p class="history-title">Participants</p>
        <div class="history">
          <div v-if="participants.length === 0">
              <p>Pas encore de participants.<br/> Soyez le premier à rejoindre!</p>
          </div>
            <div v-else v-for="part in participants" :key="part.name">
            <p>
              <strong>{{ part.name }}</strong> &nbsp;<span
                v-if="part.status === 1"
                >viens</span
              >
              <span v-if="part.status === 2">ne viens pas</span>
              &nbsp;<span v-if="part.message !== ''">(<i>{{ part.message.toLowerCase() }}</i>)</span
              >
            </p>
          </div>
        </div>
        <div class="center">
          <div class="row" v-if="button">
            <q-btn
              color="green"
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
        <div v-if="loaded" style="height: 300px; max-width: 616px" class="card map col-6">
        <l-map ref="map" :zoom="zoom" :center="[lat, long]">
          <l-tile-layer
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            layer-type="base"
            name="OpenStreetMap"
          ></l-tile-layer>
          <l-marker :lat-lng="markerLatLng" ></l-marker>
        </l-map>
      </div>
      <div v-else>
        <SpinnerComp></SpinnerComp>
      </div>

      <div class="col-4 card">
        <div class="history_comments">
          <div v-if="comments.length === 0">
            <p>Pas encore de commentaires.<br/>Laissez le premier commentaire!</p>
          </div>
          <div v-else v-for="com in comments" :key="com.id">
            <p>
              <strong>{{ com.name }}</strong
              >: {{ com.comment }}
            </p>
          </div>
        </div>
        <div class="inputBox">
          <div>
            <q-input color="green" filled v-model="comment" dense label="Commentaire" v-on:keyup.enter="addcomment">
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
            <q-input color="green" v-model="name" label="Nom" />
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
            <q-input color="green" v-if="this.$store.state.token === ''" v-model="name" label="Nom" autofocus/>
            <q-input color="green" v-model="message" label="Message (optionnel)" />
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
      long: "",
      loaded: false,
      edit: false,
      editUser: false,
      editTitle: "",
      editDescr: "",
      editDate: "",
      editTime: "",
      editAdress: "",
      editlat: 0,
      editlng: 0,
      tooltip: "copier le lien",
    };
  },
  async mounted() {
    await this.getEvent();

    this.editTitle = this.event.title;
    this.editDescr = this.event.description;
    this.editDate = this.event.date.substring(0, 10);
    this.editTime = this.event.date.substring(11, 19);
    this.editAdress = this.event.adress;

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
    this.loaded = true

    //permet de désactiver les boutons si l'utilisateur est déjà inscrit à l'événement
    if (this.$store.state.token !== "") {
      try {
        this.axios.defaults.headers.get["Authorization"] = this.$store.state.token;
        let response = await this.axios.get(this.$store.state.base_url + "/user/me?embed=all");
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
  async created() {
    /**
     * vérifie si l'utilisateur est le créateur de l'événement pour la modification d'évènement
     */
      try {
        if (this.$store.state.token !== "") {
          this.axios.defaults.headers.get["Authorization"] = this.$store.state.token;
          let response = await this.axios.get(this.$store.state.base_url + "/user/me?embed=events");
          response.data.events.forEach((e) => {
            if (e.id === this.$route.params.event_id) {
              this.editUser = true;
            }
          });
        }
      } catch (error) {
        console.log(error);
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
        this.participants = response.data.participants.sort((a,b) => {
          return new Date(a.created_at) - new Date(b.created_at);
        });
        this.comments = response.data.comments.sort((a,b) => {
          return new Date(a.created_at) - new Date(b.created_at);
        });
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
        this.axios.defaults.headers.post["Authorization"] = this.$store.state.token;
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

    async editEvent() {
      try {
        let newDate = this.editDate + "T" + this.editTime;
        await this.getadress(this.editAdress)
        this.axios.defaults.headers.put["Authorization"] = this.$store.state.token;
        await this.axios.put(this.$store.state.base_url+"/event", {
          idEvent: this.$route.params.event_id,
          title: this.editTitle,
          adress: this.editAdress,
          description: this.editDescr,
          date: newDate,
          long: this.editlng,
          lat: this.editlat,
        })
        this.getEvent()
        window.alert("Modification de l'événement réussie");
        this.edit = false
      } catch (error) {
        console.log(error);
        window.alert("Erreur lors de la modification de l'événement");
        this.edit = false
      }
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
     * récupère la longitude et la latitude d'une adresse via l'api adresse.data.gouv.fr
     * @param {String} adress
     */
    async getadress(adress) {
      try {
        let response = await fetch(
          "https://api-adresse.data.gouv.fr/search/?q=" + encodeURI(adress)
        );
        let json = await response.json()
        this.editlat = json.features[0].geometry.coordinates[1]
        this.editlng = json.features[0].geometry.coordinates[0]
      } catch (error) {
        console.log(error);
      }
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

    /**
     * change le tooltip du bouton de copie du lien
     */
    changeTooltip() {
      this.tooltip = "Lien copié !";
      navigator.clipboard.writeText(window.location.href);
      onmouseout = () => {
        this.tooltip = "Copier le lien";
      };
    }
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

.editInput {
  margin: 3px;
}
.editInput:first-of-type {
  padding-top: 19px;
  margin-top: 10px;
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
  margin-top: 10px;
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

.edit {   
  cursor: pointer;
  margin-top: -10px;
  margin-left: -100px;
  float: right;
  color: #232323;
}
.edit:hover {
  color: #4CAF50
}
</style>
