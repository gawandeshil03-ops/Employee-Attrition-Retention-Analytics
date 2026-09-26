import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const OpportunityFinder());

class OpportunityFinder extends StatelessWidget {
  const OpportunityFinder({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Baby Opportunity Finder',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
    home: const Home(),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  final jobs = <Map<String,String>>[
    {'title':'Data Analyst / Business Analyst','source':'Google Jobs','url':'https://www.google.com/search?q=Data+Analyst+Business+Analyst+fresher+India+jobs'},
    {'title':'Data Quality / Data Operations','source':'LinkedIn Jobs','url':'https://www.linkedin.com/jobs/search/?keywords=Data%20Quality%20Data%20Operations%20Fresher&location=India'},
    {'title':'Implementation / ERP / CRM','source':'Naukri','url':'https://www.naukri.com/implementation-analyst-jobs-in-india'},
    {'title':'IT Support / NOC / Network','source':'Indeed India','url':'https://in.indeed.com/jobs?q=IT+Support+NOC+Network+Fresher&l=India'},
    {'title':'Startup fresher roles','source':'Wellfound','url':'https://wellfound.com/jobs'},
  ];
  final applied = <String>{};

  Future<void> open(String url) async {
    final u=Uri.parse(url);
    if(await canLaunchUrl(u)) await launchUrl(u, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final body = tab==0 ? _home() : tab==1 ? _jobs() : tab==2 ? _profile() : _tracker();
    return Scaffold(
      appBar: AppBar(title: const Text('💗 Baby Opportunity Finder')),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected:(i)=>setState(()=>tab=i),
        destinations: const [
          NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
          NavigationDestination(icon:Icon(Icons.work_outline),selectedIcon:Icon(Icons.work),label:'Jobs'),
          NavigationDestination(icon:Icon(Icons.person_outline),selectedIcon:Icon(Icons.person),label:'Profile'),
          NavigationDestination(icon:Icon(Icons.checklist_outlined),selectedIcon:Icon(Icons.checklist),label:'Tracker'),
        ],
      ),
    );
  }

  Widget _home()=>ListView(padding:const EdgeInsets.all(18),children:[
    Text('Your job-search assistant',style:Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height:8),
    const Text('Default profile: 2026 E&TC fresher • India/Pune • low/no-code preferred • ₹3 LPA+ when salary is disclosed.'),
    const SizedBox(height:18),
    _card('🔎 Find opportunities','Open targeted searches across job boards and startup sources.',Icons.search,()=>setState(()=>tab=1)),
    _card('📄 Tailor CV','Copy this prompt into ChatGPT/Claude with a job description to tailor your resume.',Icons.description,()=>_showPrompt()),
    _card('🚫 Exclusions','Sales, BD, cold calling, telesales, field sales, commission-only and marketing roles are excluded by default.',Icons.block,null),
    _card('🔗 Direct links','The app opens external job/search pages. It does not claim a listing is genuine unless verified.',Icons.link,null),
  ]);

  Widget _jobs()=>ListView.builder(
    padding:const EdgeInsets.all(12),itemCount:jobs.length,itemBuilder:(c,i){
      final j=jobs[i]; final done=applied.contains(j['title']);
      return Card(child:ListTile(
        leading:CircleAvatar(child:Text((i+1).toString())),
        title:Text(j['title']!),
        subtitle:Text(j['source']!),
        trailing:Wrap(spacing:4,children:[
          IconButton(icon:Icon(done?Icons.check_circle:Icons.check_circle_outline),onPressed:()=>setState(()=>done?applied.remove(j['title']):applied.add(j['title']!))),
          IconButton(icon:const Icon(Icons.open_in_new),onPressed:()=>open(j['url']!)),
        ]),
      ));
    });

  Widget _profile()=>ListView(padding:const EdgeInsets.all(18),children:[
    Text('Default profile',style:Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height:12),
    const ListTile(title:Text('Education'),subtitle:Text('B.E./B.Tech E&TC • 2026 fresher')),
    const ListTile(title:Text('Preferred roles'),subtitle:Text('Data Analyst, BA, Data Quality, Data Operations, MIS, Implementation, ERP/CRM, IT Support, NOC, Network Support, PMO')),
    const ListTile(title:Text('Preferences'),subtitle:Text('India/Pune • office roles • low/no-code • ₹3 LPA+ where disclosed')),
    const ListTile(title:Text('Exclude'),subtitle:Text('Sales, BD, cold calling, telesales, field sales, commission-only, marketing, senior roles, 2+ years experience')),
  ]);

  Widget _tracker()=>ListView(padding:const EdgeInsets.all(18),children:[
    Text('Application tracker',style:Theme.of(context).textTheme.headlineSmall),
    const SizedBox(height:12),
    Text('Marked applications: '+applied.length.toString()),
    ...applied.map((x)=>ListTile(leading:const Icon(Icons.check),title:Text(x))),
  ]);

  Widget _card(String title,String sub,IconData icon,VoidCallback? action)=>Card(
    child:ListTile(leading:Icon(icon),title:Text(title),subtitle:Text(sub),onTap:action),
  );

  void _showPrompt()=>showDialog(context:context,builder:(c)=>AlertDialog(
    title:const Text('CV tailoring prompt'),
    content:const SingleChildScrollView(child:Text(
      'Act as an ATS resume specialist. Compare my resume with the job description. Keep every claim truthful. '
      'Return: (1) matched keywords, (2) missing but learnable keywords, (3) a one-page tailored resume, '
      '(4) a short application message. Do not invent experience, salary, certifications or employment history.'
    )),
    actions:[TextButton(onPressed:()=>Navigator.pop(c),child:const Text('Close'))],
  ));
}
