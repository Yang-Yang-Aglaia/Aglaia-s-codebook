<!DOCTYPE html>
<html>
 <head>
    <title>My experiment</title>
    <script src="jspsych-6.3.0/jspsych.js"></script>
    <script src="jspsych-6.3.0/plugins/jspsych-html-keyboard-response.js"></script>
    <script src="jspsych-6.3.0/plugins/jspsych-image-keyboard-response.js"></script>
    <script src="jspsych-6.3.0/plugins/jspsych-preload.js"></script>
    <link href="jspsych-6.3.0/css/jspsych.css" rel="stylesheet" type="text/css">
 </head>
  <body></body>
  <script>
 /*以上都是必需的代码 */
 /*jspsych-image-keyboard-response.js为刺激相关插件，其中刺激文件夹要放在experiment文件夹中，并命名img*/
 /*jspsych-html-keyboard-response.js为按键相关插件*/
 /*jspsych-preload.js为提前上传刺激相关插件*/

    /* create timeline */
    var timeline = [];

    /*提前上传刺激*/
    var preload = {
    type: 'preload',
    images: ['img/blue.png', 'img/orange.png']
    }
    timeline.push(preload);

    /* define welcome message trial */
    var welcome = {
      type: "html-keyboard-response",
      stimulus: "Welcome to the experiment. Press any key to begin."
    };
    timeline.push(welcome);

    /* create instruction */
    var instructions = {
    type: "html-keyboard-response",
    stimulus: `
      <p>In this experiment, a circle will appear in the center
      of the screen.</p><p>If the circle is <strong>blue</strong>,
      press the letter F on the keyboard as fast as you can.</p>
      <p>If the circle is <strong>orange</strong>, press the letter J
      as fast as you can.</p>
      <div style='width: 700px;'>
      <div style='float: left;'><img src='img/blue.png'></img>
      <p class='small'><strong>Press the F key</strong></p></div>
      <div class='float: right;'><img src='img/orange.png'></img>
      <p class='small'><strong>Press the J key</strong></p></div>
      </div>
      <p>Press any key to begin.</p>
    `,
    post_trial_gap: 2000  /*指导语呈现时间*/
    };
    timeline.push(instructions);

    /* test trials */
    var blue_trial = {
    type: 'image-keyboard-response',
    stimulus: 'img/blue.png',    /*这里的img是文件夹名字，可以修改。后面跟着刺激名*/
    choices: ['p', 'q']};

    var orange_trial = {
    type: 'image-keyboard-response',
    stimulus: 'img/orange.png',
    choices: ['f', 'j']
    }

    timeline.push(blue_trial, orange_trial);



    /* test trials of repeat*/

    /* 定义所有要出现的刺激 */
    var test_stimuli = [
        /*定义正确按键*/
      { stimulus: "img/blue.png", correct_response: 'f'},
      { stimulus: "img/orange.png", correct_response: 'j'}
    ];


    /* 定义注视点 */
    var fixation = {
      type: 'html-keyboard-response',
      stimulus: '<div style="font-size:60px;">+</div>',
      choices: jsPsych.NO_KEYS,   /*无有效反应*/
      trial_duration: function(){
          return jsPsych.randomization.sampleWithoutReplacement([250, 500, 750, 1000, 1250, 1500, 1750, 2000], 1)[0];
      },  /*刺激呈现时间*/
      /*从以上呈现时间序列中抽取一个数字，并且在末尾添加[0]选项，以获取数组中的值*/
      data: {
          task: 'fixation'
      }
    }

    /* 为了展示循环试次情况，利用 jsPsych.timelineVariable表示要在时间线上重复的内容，此处只有两个试次，两个刺激分别呈现一次*/
    var test = {
      type: "image-keyboard-response",
      stimulus: jsPsych.timelineVariable('stimulus'),
      choices: ['f', 'j'],
      data: {
          task: 'response',
          correct_response: jsPsych.timelineVariable('correct_response')
      },  /*在数据中标记反应*/
      on_finish: function(data){
        data.correct = jsPsych.pluginAPI.compareKeys(data.response, data.correct_response);
        /*简单的数据分析，即计算每次被试反应的对错 */
      }
    }

    /* 构建新的时间线展示出来*/
    var test_procedure = {
      timeline: [fixation, test],
      timeline_variables: test_stimuli,
      randomize_order: true,   /*随机呈现*/
      repetitions: 5  /*试次数*/
    }

    timeline.push(test_procedure);


    /* define debrief */
    /*数据整合*/
    var debrief_block = {
        type: "html-keyboard-response",
        stimulus: function() {

        var trials = jsPsych.data.get().filter({task: 'response'});  /*实验中收集到的所有数据*/
        var correct_trials = trials.filter({correct: true});   /*只看需要反应的刺激的数据，这里选择的是正确*/
        var accuracy = Math.round(correct_trials.count() / trials.count() * 100);  /*多少试次反应正确，其中Math.round避免小数点多加位数*/
        var rt = Math.round(correct_trials.select('rt').mean());  /*计算反应时均值*/

        /**/
        return `<p>You responded correctly on ${accuracy}% of the trials.</p>
        <p>Your average response time was ${rt}ms.</p>
        <p>Press any key to complete the experiment. Thank you!</p>`;
        }
    };

timeline.push(debrief_block);


    /* start the experiment */
    jsPsych.init({
      timeline: timeline,
      on_finish: function() {
        jsPsych.data.displayData();   /*收集数据*/
      }
    });
  </script>
</html>

