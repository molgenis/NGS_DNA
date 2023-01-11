node {
	stage ('Checkout') {
		checkout scm
	}
        stage ('Automated test') {
        
        echo "Copy test from repo to molgenis home on Gearshift"
        sh "sudo scp test/test_pipeline.sh airlock+gearshift:/home/umcg-molgenis/test_pipeline_DNA.sh"
        
        echo "Login to Gearshift"
	    
	sh '''
            sudo ssh -tt airlock+gearshift 'exec bash -l << 'ENDSSH'
	    	echo "Starting automated test"
		bash /home/umcg-molgenis/test_pipeline.sh '''+env.CHANGE_ID+'''
ENDSSH'
        '''	
	}
}
