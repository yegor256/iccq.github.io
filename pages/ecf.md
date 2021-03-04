---
layout: default
date: 2021-02-23
title: "IEEE Electronic Copyright Form"
permalink: /ecf.html
---

Review the information in this form and click "Submit" in order to transfer
your ownership rights of the intellectual property to IEEE.
The data will be sent to
[IEEE eCF system](https://www.ieee.org/publications/rights/copyright-main.html).

<script src="//code.jquery.com/jquery-1.9.0.min.js"></script>
<script>
var papers = {
  1: {
    'title': 'Foreword of Organizers',
    'authors': 'Yegor Bugayenko'
  },
  2: {
    'title': 'Learning to find bugs and code quality problems - what worked and what not?',
    'authors': 'Veselin Raychev'
  },
  14: {
    'title': 'Towards a Prototype Based Explainable JavaScript Vulnerability Prediction Model',
    'authors': 'Balázs Mosolygó, Norbert Vándor, Gábor Antal, Péter Hegedűs and Rudolf Ferenc'
  },
  19: {
    'title': 'An Efficient Dynamic Analysis Tool for Checking Durable Linearizability',
    'authors': 'Christina Peterson and Damian Dechev'
  },
  20: {
    'title': 'Qualitative and Quantitative Analysis of Callgraph Algorithms for PYTHON',
    'authors': 'Sriteja Kummita, Goran Piskachev, Johannes Spaeth and Eric Bodden'
  },
  23: {
    'title': 'Exploring the Effect of NULL Usage in Source Code',
    'authors': 'Ekaterina Garmash and Anton Cheshkov'
  },
  24: {
    'title': 'Striffs: Architectural Component Diagrams for Code Reviews',
    'authors': 'Muntazir Fadhel and Emil Sekerinski'
  },
  16: {
    'title': 'Raising Security Awareness using Cybersecurity Challenges in Embedded Programming Courses',
    'authors': 'Tiago Espinha Gasiba, Samra Hodzic, Ulrike Lechner and Maria Pinto-Albuquerque'
  },
};
$(function() {
  let p = new URLSearchParams(window.location.search);
  aid = parseInt(p.get('id'));
  var details = papers[aid];
  if (details == undefined) {
    window.location.href = "/404.html";
  }
  $('input[name="ArtId"]').val(aid);
  $('input[name="ArtTitle"]').val(details.title);
  $('input[name="AuthName"]').val(details.authors);
});
</script>

<form action="https://ecopyright.ieee.org/ECTT/IntroPage.jsp" method="post">
  <fieldset>
    <input type="hidden" name="ArtSource" value="51190"/>
    <input type="hidden" name="rtrnurl" value="https://www.iccq.ru/ecf-success.html"/>
    <label>Conference Title:</label>
    <input type="text" required readonly size="50" name="PubTitle" value="2021 International Conference on Code Quality (ICCQ)"/>
    <label>Article ID:</label>
    <input type="text" required readonly size="5" name="ArtId" value="12345"/>
    <label>Article Title:</label>
    <input type="text" required readonly size="60" name="ArtTitle" value="On Fluid Queuing Systems with Strict Priority"/>
    <label>Author Names:</label>
    <input type="text" required readonly size="55" name="AuthName" value="Yong Liu and Weibo Gong"/>
    <label>Author Emails:<sup class='firebrick'>*</sup></label>
    <input type="text" size="58" name="AuthEmail" placeholder="y.liu@ieee.org,a.smith@ieee.org"/>
    <label></label>
    <input name="Submit" type="submit" value="Submit"/>
  </fieldset>
</form>

If any questions, email us [team@iccq.ru](mailto:team@iccq.ru).