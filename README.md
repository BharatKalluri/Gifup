<p align="center">
    <img src="https://github.com/BharatKalluri/Gifup/blob/master/data/icons/128/com.github.bharatkalluri.gifup.svg" alt="icon"> <br>
</p>

<div>
  <h1 align="center">Gifup</h1>
  <h3 align="center">Create GIFs from video files, written for the elementary OS.</h3>
</div>

<br/>

<p align="center">
   <a href="https://github.com/bharatkalluri/Gifup/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-GPL--3.0-blue.svg">
   </a>
</p>

<p align="center">
    <img src="https://github.com/BharatKalluri/Gifup/blob/master/Screenshot.png" alt="Screenshot"> <br>
  <a href="https://github.com/bharatkalluri/Gifup/issues/new"> Report a problem! </a>
</p>

### Installation

#### From source
You'll need the following dependencies:

* ffmpeg
* libgtk-3.0-dev
* meson
* valac

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

    meson build --prefix=/usr
    cd build
    ninja

To install, use `ninja install`, then execute with `com.github.bharatkalluri.gifup`

    sudo ninja install
    com.github.bharatkalluri.gifup

#### Flatpak
A Flaptak json is already present in the repo. It will be uploaded to flathub shortly.
