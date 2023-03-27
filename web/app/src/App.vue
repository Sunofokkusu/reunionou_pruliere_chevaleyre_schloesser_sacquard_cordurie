<template>
    <div class="main">
        <div class="title unselectable">
            <h1 @click="this.$router.push({name:'HomePage'})">Reunionou</h1>
        </div>
        <router-view/>
    </div>
</template>

<script>

export default {
  name: 'LayoutDefault',
}
</script>

<style>

body {
    background-color: #f6f4f4;
}

.main {
    padding: 10px;
    width: 100%;
    height: 100%;
}

.title{
    margin: -50px -10px -30px -10px;
    padding: 15px 10px 5px 20px;
    font-size: 4em;
    color: white;
    border-radius: 0 0 15px 15px;
    background-color: #3988ff;
}

.title>h1{
    font-size: 1em;
    max-width: 490px;
    height: 90px;
    line-height: 90px;
    cursor: pointer;
    color: white;
    font-family: fredoka;
    display: block;
    background-size: 200% 100%;
    background-image: linear-gradient(to right, #ffffff 50%, #8be4ff 50%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    transition: background-position 0.5s;
}
.title>h1:hover{
    background-position: -100% 0;
}

.unselectable {
    -moz-user-select: none;
    -khtml-user-select: none;
    -webkit-user-select: none;
    -ms-user-select: none;
    user-select: none;
}

::-webkit-scrollbar {
    width: 10px;
}

::-webkit-scrollbar-thumb {
    background: #666;
    border-radius: 20px;
}

::-webkit-scrollbar-track {
    background: #cccccc;

}
</style>
