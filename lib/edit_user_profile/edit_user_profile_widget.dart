import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/firebase_storage/storage.dart';
import '../flutter_flow/flutter_flow_checkbox_group.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_radio_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/upload_media.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUserProfileWidget extends StatefulWidget {
  const EditUserProfileWidget({Key? key}) : super(key: key);

  @override
  _EditUserProfileWidgetState createState() => _EditUserProfileWidgetState();
}

class _EditUserProfileWidgetState extends State<EditUserProfileWidget> {
  bool isMediaUploading = false;
  String uploadedFileUrl = '';

  TextEditingController? yourNameController;
  TextEditingController? phoneNumberController;
  List<String>? proposedActivitiesValues;
  List<String>? workDaysValues;
  String? studyGroupValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    phoneNumberController?.dispose();
    yourNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primaryColor,
              ),
            ),
          );
        }
        final editUserProfileUsersRecord = snapshot.data!;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              buttonSize: 46,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 24,
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Seu perfil',
              style: FlutterFlowTheme.of(context).title2,
            ),
            actions: [],
            centerTitle: false,
            elevation: 0,
          ),
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(16, 0, 24, 16),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Preencha agora seu perfil para completar seu registro.',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyText2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final selectedMedia =
                                        await selectMediaWithSourceBottomSheet(
                                      context: context,
                                      allowPhoto: true,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .tertiaryColor,
                                      textColor: FlutterFlowTheme.of(context)
                                          .primaryDark,
                                      pickerFontFamily: 'Lexend Deca',
                                    );
                                    if (selectedMedia != null &&
                                        selectedMedia.every((m) =>
                                            validateFileFormat(
                                                m.storagePath, context))) {
                                      setState(() => isMediaUploading = true);
                                      var downloadUrls = <String>[];
                                      try {
                                        showUploadMessage(
                                          context,
                                          'Uploading file...',
                                          showLoading: true,
                                        );
                                        downloadUrls = (await Future.wait(
                                          selectedMedia.map(
                                            (m) async => await uploadData(
                                                m.storagePath, m.bytes),
                                          ),
                                        ))
                                            .where((u) => u != null)
                                            .map((u) => u!)
                                            .toList();
                                      } finally {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        isMediaUploading = false;
                                      }
                                      if (downloadUrls.length ==
                                          selectedMedia.length) {
                                        setState(() => uploadedFileUrl =
                                            downloadUrls.first);
                                        showUploadMessage(context, 'Success!');
                                      } else {
                                        setState(() {});
                                        showUploadMessage(
                                            context, 'Failed to upload media');
                                        return;
                                      }
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .gray200,
                                              image: DecorationImage(
                                                fit: BoxFit.fitWidth,
                                                image: Image.network(
                                                  valueOrDefault<String>(
                                                    uploadedFileUrl != null &&
                                                            uploadedFileUrl !=
                                                                ''
                                                        ? uploadedFileUrl
                                                        : editUserProfileUsersRecord
                                                            .photoUrl,
                                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/cepac-dtrv3d/assets/cc1p30hl0z2w/no_photo.png',
                                                  ),
                                                ).image,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.95, 0.98),
                                          child: Icon(
                                            Icons.add_circle,
                                            color: Colors.black,
                                            size: 36,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: yourNameController ??=
                                          TextEditingController(
                                        text: editUserProfileUsersRecord
                                            .displayName,
                                      ),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Seu nome completo',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .subtitle2,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                      ),
                                      style:
                                          FlutterFlowTheme.of(context).title2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 12, 0, 0),
                                      child: TextFormField(
                                        controller: phoneNumberController ??=
                                            TextEditingController(
                                          text: editUserProfileUsersRecord
                                              .phoneNumber,
                                        ),
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          labelText: 'Número celular/whatsapp',
                                          labelStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText2,
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          errorBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(4.0),
                                              topRight: Radius.circular(4.0),
                                            ),
                                          ),
                                        ),
                                        style:
                                            FlutterFlowTheme.of(context).title3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: DefaultTabController(
                          length: 3,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                labelColor:
                                    FlutterFlowTheme.of(context).primaryColor,
                                unselectedLabelColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                                labelPadding:
                                    EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                                labelStyle:
                                    FlutterFlowTheme.of(context).bodyText1,
                                indicatorColor:
                                    FlutterFlowTheme.of(context).primaryColor,
                                tabs: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 10, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.peopleCarry,
                                        ),
                                      ),
                                      Tab(
                                        text: 'Grupos de\nestudo',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 10, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.solidCalendarAlt,
                                        ),
                                      ),
                                      Tab(
                                        text: 'Dias de\ntrabalho',
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            10, 0, 10, 0),
                                        child: FaIcon(
                                          FontAwesomeIcons.networkWired,
                                        ),
                                      ),
                                      Tab(
                                        text: 'Atividades\npropostas',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    KeepAliveWidgetWrapper(
                                      builder: (context) => Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                        child: FlutterFlowRadioButton(
                                          options: [
                                            'A Gênese \nSábados',
                                            'Evangelização\nSábados',
                                            'Iniciantes\nQuintas',
                                            'Inicianes\nSábados',
                                            'O livro dos espíritos\nQuintas',
                                            'O livro dos espíritos\nSábados',
                                            'O livro dos médiuns\nQuintas',
                                            'O livro dos médiuns\nSábados',
                                            'Léon Denis - Obras\nQuartas',
                                            'Os missionários da luz\nSextas'
                                          ].toList(),
                                          onChanged: (val) => setState(
                                              () => studyGroupValue = val),
                                          optionHeight: 35,
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1
                                                  .override(
                                                    fontFamily: 'Urbanist',
                                                    color: Colors.black,
                                                  ),
                                          buttonPosition:
                                              RadioButtonPosition.left,
                                          direction: Axis.vertical,
                                          radioButtonColor: Colors.blue,
                                          inactiveRadioButtonColor:
                                              Color(0x8A000000),
                                          toggleable: false,
                                          horizontalAlignment:
                                              WrapAlignment.start,
                                          verticalAlignment:
                                              WrapCrossAlignment.start,
                                        ),
                                      ),
                                    ),
                                    KeepAliveWidgetWrapper(
                                      builder: (context) => Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                        child: AuthUserStreamWidget(
                                          builder: (context) =>
                                              FlutterFlowCheckboxGroup(
                                            initiallySelected:
                                                (currentUserDocument?.workDays
                                                        ?.toList() ??
                                                    []),
                                            options: [
                                              'Domingo',
                                              'Segunda-Feira',
                                              'Terça-Feira',
                                              'Quarta-Feira',
                                              'Quinta-Feira',
                                              'Sexta-Feira',
                                              'Sábado'
                                            ],
                                            onChanged: (val) => setState(
                                                () => workDaysValues = val),
                                            activeColor:
                                                FlutterFlowTheme.of(context)
                                                    .primaryColor,
                                            checkColor: Colors.white,
                                            checkboxBorderColor:
                                                Color(0xFF95A1AC),
                                            textStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyText1,
                                            initialized: workDaysValues != null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    KeepAliveWidgetWrapper(
                                      builder: (context) =>
                                          AuthUserStreamWidget(
                                        builder: (context) =>
                                            FlutterFlowCheckboxGroup(
                                          initiallySelected:
                                              (currentUserDocument
                                                      ?.proposedActivities
                                                      ?.toList() ??
                                                  []),
                                          options: [
                                            'Responsável reunião',
                                            'Recepção',
                                            'Dirigente reunião pública',
                                            'Prece inicial',
                                            'Encaminhamento',
                                            'Passe',
                                            'Servir água',
                                            'Atendimento fraterno'
                                          ],
                                          onChanged: (val) => setState(() =>
                                              proposedActivitiesValues = val),
                                          activeColor:
                                              FlutterFlowTheme.of(context)
                                                  .primaryColor,
                                          checkColor: Colors.white,
                                          checkboxBorderColor:
                                              Color(0xFF95A1AC),
                                          textStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyText1,
                                          initialized:
                                              proposedActivitiesValues != null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: FFButtonWidget(
                              onPressed: () async {
                                final usersUpdateData = {
                                  ...createUsersRecordData(
                                    displayName: yourNameController?.text ?? '',
                                    photoUrl: uploadedFileUrl != null &&
                                            uploadedFileUrl != ''
                                        ? uploadedFileUrl
                                        : editUserProfileUsersRecord.photoUrl,
                                    studyGroup: studyGroupValue,
                                    phoneNumber:
                                        phoneNumberController?.text ?? '',
                                  ),
                                  'work_days': workDaysValues!.length > 0
                                      ? workDaysValues
                                      : editUserProfileUsersRecord.workDays!
                                          .toList(),
                                  'proposed_activities':
                                      proposedActivitiesValues!.length > 0
                                          ? proposedActivitiesValues
                                          : editUserProfileUsersRecord
                                              .proposedActivities!
                                              .toList(),
                                };
                                await currentUserReference!
                                    .update(usersUpdateData);
                                Navigator.pop(context);
                              },
                              text: 'Gravar alterações',
                              options: FFButtonOptions(
                                width: 200,
                                height: 50,
                                color:
                                    FlutterFlowTheme.of(context).primaryColor,
                                textStyle: FlutterFlowTheme.of(context)
                                    .subtitle2
                                    .override(
                                      fontFamily: 'Urbanist',
                                      color: Colors.white,
                                    ),
                                elevation: 2,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
