<template>
  <div>
    <div class="card">
      <div class="white">
        Une application pour se fixer un rendez-vous en groupe
      </div>
    </div>
    <div v-if="connected" class="row">

      <div class="cardNav">
        <p class="unselectable card-select" :class="classActive1" @click="this.getEvents('all'); cardSelectActive(1)">Voir tout</p>
        <p class="unselectable card-select" :class="classActive2" @click="this.getEvents('events'); cardSelectActive(2)">Mes évènements</p>
        <p class="unselectable card-select" :class="classActive3" @click="this.getEvents('invited'); cardSelectActive(3)">Mes participations</p>
      </div>

      <div class="eventCard addCard col-2" label="Confirm" @click="confirm = true">
        <p class="unselectable">Nouvel évènement</p>
        <p class="add unselectable">+</p>
      </div>

      <div v-if="this.eventLoading" class="eventCard col-2">
        <SpinnerComp>
        </SpinnerComp>
      </div>
      <div v-if="this.eventError" class="eventCard col-2">
        <p class="unselectable">Erreur lors de la récupération des évènements</p>
      </div>
      <div v-else class="eventCard col-2" v-for="event in events" :key="event.id" @click="this.$router.push({ name: 'Event', params: { event_id: event.id } })">
        <p class="unselectable">{{ event.title }}</p>
        <p class="unselectable">{{ event.description }}</p>
        <p class="unselectable">
          {{ new Date(event.date.substr(0, 10)).toLocaleDateString() }}
        </p>
        <p class="unselectable">
          {{ event.date.substr(11, 5) }}<br/>
        </p>
        <p class="unselectable">{{ event.adress }}</p>
      </div>
    </div>

    <div v-else class="row">
      <div class="col-12 eventCard">
        <p class="unselectable">Vous devez être connecté pour accéder aux évènements</p>
      </div>
    </div>

    <q-dialog v-model="confirm" persistent>
      <q-card class="modal">
        <q-card-section class="row items-center">
          <div class="q-ml-sm">
            <p class="text-h6">Nouvel évènement</p>
            <q-input color="green" v-model="title" label="Libellé*" autofocus />
            <q-input color="green" v-model="description" label="Description" />
            <q-input color="green" v-model="meetingDate" type="date" label="Date de rendez-vous*"/>
            <q-input color="green" v-model="meetingHour" type="time" label="Heure de rendez-vous*"/>
            <q-input color="green" v-model="adress" label="Lieu de rendez-vous*" />
          </div>
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="Annuler" color="negative" v-close-popup @Click="reset"/>
          <q-btn flat label="Ajouter" color="primary" v-close-popup @Click="addevent" :disable="verifEmpty"/>
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
import SpinnerComp from "./Spinner.vue";
export default {
  name: "HomePage",
  components: {
    SpinnerComp,
  },
  data() {
    return {
      confirm: false,
      title: "",
      description: "",
      meetingDate: "",
      meetingHour: "",
      adress: "",
      lat: 0,
      lng: 0,
      events: [],
      errored: false,
      eventLoading: true,
      eventError: false,
      classActive1: "card-select-active",
      classActive2: "card-select-deactive",
      classActive3: "card-select-deactive",
    };
  },
  mounted() {
    if(this.$store.state.token){
      this.getEvents('all');
    }
  },
  computed: {
    connected() {
      return this.$store.state.connected;
    },

    /**
     * vérifie si les champs obligatoires sont remplis
     * @returns {boolean} true si les champs obligatoires sont remplis, false sinon
     */
    verifEmpty() {
      if (
        this.title !== "" &&
        this.meetingDate !== "" &&
        this.meetingHour !== "" &&
        this.adress !== ""
      ) {
        return false;
      } else {
        return true;
      }
    },
  },
  methods: {
    /**
     * Fonction qui permet de récupérer tous les évènements où l'utilisateur participe ou ceux qu'il a créer
     * @return intutilisable
     */
    async getEvents(select) {
      try {
        // this.axios.defaults.headers.get["ngrok-skip-browser-warning"] = "true"
        this.axios.defaults.headers.get["Authorization"] = this.$store.state.token
        let response = await this.axios.get(this.$store.state.base_url + "/user/me?embed="+select, {})
        if(response.data.events !== undefined || response.data.events !== []){
          if(select === "invited"){
            this.events = response.data.invited
          }else{
            this.events = response.data.events;
          }
        }
        this.eventError = false;
        this.eventLoading = false;
      } catch (error) {
        console.log(error);
        this.eventError = true;
        this.eventLoading = false;
      }
    },

    /**
     * permet d'ajouter un evenement
     * @return inutilisable
     */
    async addevent() {
      if (
        this.title !== "" &&
        this.meetingDate !== "" &&
        this.meetingHour !== "" &&
        this.adress !== ""
      ) {
        this.errored = false;

        this.meetingDate = this.meetingDate + "T" + this.meetingHour + ":00";

        try {
          await this.getadress(this.adress);
          this.axios.defaults.headers.post["Authorization"] =
            this.$store.state.token;
          let response = await this.axios.post(this.$store.state.base_url + "/event", {
            title: this.title,
            description: this.description,
            date: this.meetingDate,
            adress: this.adress,
            lat: this.lat,
            long: this.lng,
          });

          this.events.push({
            token: response.data.token,
            title: this.title,
            description: this.description,
            date: this.meetingDate,
            adress: this.adress,
            lat: this.lat,
            long: this.lng,
          });

          this.reset();
          this.$router.push({name:'Event', params: { event_id: response.data.id }})
        } catch (error) {
          console.log(error);
        }
      } else {
        this.errored = true;
      }
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
        this.lat = json.features[0].geometry.coordinates[1]
        this.lng = json.features[0].geometry.coordinates[0]
      } catch (error) {
        console.log(error);
      }
    },

    /**
     * vide les champs du formulaire
     * @return inutilisable
     */
    reset() {
      this.title = "";
      this.description = "";
      this.meetingDate = "";
      this.meetingHour = "";
      this.adress = "";
    },

    /**
     * permet de changer la couleur de la carte en fonction de la selection
     * @param {int} num numéro de la carte
     */
    cardSelectActive(num) {
      switch (num) {
        case 1:
          this.classActive1 = "card-select-active";
          this.classActive2 = "card-select-deactive";
          this.classActive3 = "card-select-deactive";
          break;
        case 2:
          this.classActive1 = "card-select-deactive";
          this.classActive2 = "card-select-active";
          this.classActive3 = "card-select-deactive";
          break;
        case 3:
          this.classActive1 = "card-select-deactive";
          this.classActive2 = "card-select-deactive";
          this.classActive3 = "card-select-active";
          break;
      }
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
  min-height: 100px;
  background: url("../assets/back.svg");
  background-size: 100% auto;
  background-repeat: no-repeat;
}

.eventCard {
  cursor: pointer;
  text-align: center;
  border-radius: 10px;
  background-color: #fff;
  margin: 8px;
  width: 200px !important;
  height: 200px !important;
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
  transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s, filter 0.1s;
}
.eventCard > p {
  margin-top: -10px;
}
.eventCard:hover {
  width: 207px !important;
  height: 207px !important;
  margin: 5px;
  filter: brightness(99%);
}
.eventCard:active {
  filter: brightness(93%);
}
.eventCard > p:first-of-type {
  margin-top: 30px;
  font-size: 1.5em;
}

.add {
  margin-top: -45px !important;
  font-size: 7em;
  color: #A5D6A7;
}
.addCard {
  background-color: mintcream ;
}
.addCard:hover > .add {
  color: #4CAF50;
}

.modal {
  padding-right: 10px;
  text-align: center;
}

.red {
  color: red;
}

.white {
  font-size: 220%;
  padding: 15px 10px 10px 10px;
}

.cardNav {
  text-align: center;
  border-radius: 10px;
  background-color: mintcream;
  margin: 8px;
  width: 200px !important;
  height: 200px !important;
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
}

.card-select {
  display: flex;
  box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 3px 0px;
  cursor: pointer;
  text-align: center;
  border-radius: 10px;
  margin: 12px;
  height: 50px !important;
  font-size: 1.1em !important;
  align-items: center;
  justify-content: center;
  transition: width 0.2s, height 0.2s, margin 0.2s, padding 0.2s, filter 0.1s;
}
.card-select:first-of-type {
  margin-top: 11px !important;
}
.card-select:hover {
  filter: brightness(96%);
  margin-left: 7px !important;
  margin-right: 7px !important;
}
.card-select:active {
  filter: brightness(90%);
}
.card-select-deactive {  
  background-color: #A5D6A7;
}
.card-select-active {
  background-color: #4CAF50;
}


</style>
