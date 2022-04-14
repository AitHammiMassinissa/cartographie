PImage carte;
Table pos;
int lignes;
Table donnees;
Table maison;
String nom_maison;
float nombre_fans;
float dmin = 1000;
float dmax = 8000;
boolean overellipse = false;
boolean locked = false;
Integrator[] interp;

void setup() {
    size(640, 400);
    carte = loadImage("grandest.png");
    pos = new Table("position.tsv");
    lignes = pos.getRowCount();
    donnees = new Table("fans.tsv");
    maison = new Table("maison.tsv");

    // On charge les valeurs initiales dans les interpolateurs :
    interp = new Integrator[lignes];
    for(int ligne = 0; ligne < lignes; ligne++) {
        interp[ligne] = new Integrator(donnees.getFloat(ligne, 1),0.2, 0.2);
    }

    noStroke();
}

void draw() {
    background(255);
    image(carte, 0, 0);
    for(int ligne = 0; ligne < lignes; ligne++) {
        interp[ligne].update();
        String cle = donnees.getRowName(ligne);
        float x = pos.getFloat(cle, 1);
        float y = pos.getFloat(cle, 2);
        dessinerDonnees(x, y, ligne,cle);
    }
}

void dessinerDonnees(float x, float y, int ligne,String cle) {
    float valeur = interp[ligne].value;
    float m = maison.getFloat(cle, 1);
    float taille = map(valeur, 0, dmax, 10, 70);
    nombre_fans=valeur;
    PFont font = createFont("andalemo.ttf", 15);
    fill(lerpColor(#FF4422, #4422CC, norm(donnees.getFloat(cle, 1), dmin, dmax)));
    
    ellipse(x, y, taille, taille);
   if (mouseX > x-taille && mouseX < x+taille && 
      mouseY > y-taille && mouseY < y+taille) {
    overellipse = true;  
    if(!locked) { 
      if(m==1){
         nom_maison= "Barathéon";
        textFont(font);
        text(nom_maison, x, y-50);
        text(nombre_fans, x, y-30);
        textAlign(CENTER);  
      }else if(m==2){
          nom_maison= "Targaryen";
         textFont(font);
        text(nom_maison, x, y-50);
        text(nombre_fans, x, y-30);
        textAlign(CENTER);  
      }else if(m==3){
          nom_maison= "Stark";
         textFont(font);
        text(nom_maison, x, y-50);
        text(nombre_fans, x, y-30);
        textAlign(CENTER);  
      }else if(m==4){
        nom_maison= "Lannister";
       textFont(font);
        text(nom_maison, x, y-50);
        text(nombre_fans, x, y-30);
        textAlign(CENTER);  
      }
    } 
  } else {
    stroke(153);
    fill(153);
    overellipse = false;
  }
}

void keyPressed() {
    if(key == ' ') majDonnees();
}

void majDonnees() {
 for(int ligne = 0; ligne < lignes; ligne++) {
        interp[ligne].target(random(dmin, dmax));
    }


}
