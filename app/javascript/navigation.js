const navButton = document.getElementById('nav-button');
const navClassList = document.getElementById('nav').classList;
const main = document.getElementById('main').classList;

navButton.addEventListener('click', changeNavClass);

function changeNavClass(){
  if (navClassList.contains('hidden')){
    navClassList.remove('hidden');
    main.add('blur')
  } else {
    navClassList.add('hidden');
    main.remove('blur')
  }
}