--席取－六双丸
function c101108047.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	-- Roll die and move to corresponding zone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108047,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_CONTROL+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101108047.mvcon)
	e1:SetTarget(c101108047.mvtg)
	e1:SetOperation(c101108047.mvop)
	c:RegisterEffect(e1)
end
c101108047.roll_dice=true
function c101108047.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_START and Duel.GetTurnPlayer()==1-tp and e:GetHandler():GetSequence()<5
end
function c101108047.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c101108047.cannot_move(c)
	Duel.SendtoGrave(c,REASON_EFFECT)
end
function c101108047.mvop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_SEKITORI=0x22
	local WIN_REASON_GHOSTRICK_SPOILEDANGEL=0x1b
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:GetSequence()>4 then return end
	local dice=Duel.TossDice(tp,1)
	if dice<1 or dice>6 then return end
	local seq=c:GetSequence()
	local max=5
	for i=1,dice do
		seq=seq-1
		if seq<-max then seq=max-1 end
	end
	local switch=seq<0
	if switch and not c:IsAbleToChangeControler() then return c101108047.cannot_move(c) end
	local fp=switch and 1-tp or tp
	local nseq=switch and 5+seq or seq
	local tc=Duel.GetFieldCard(fp,LOCATION_MZONE,nseq)
	if Duel.GetMZoneCount(fp,tc,tp,nil,1<<nseq)<1 then return c101108047.cannot_move(c) end
	local win=false
	local winct=false
	if tc then
		if c==tc or tc:IsImmuneToEffect(e) or tc:IsType(TYPE_TOKEN) then return c101108047.cannot_move(c) end
		local prev=c:GetOverlayCount()
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(c,mg) end
		Duel.Overlay(c,Group.FromCards(tc))
		winct=(prev<7 and c:GetOverlayCount()>6)
	end
	if switch and Duel.GetControl(c,1-tp,0,0,1<<nseq) then
		win=true
	else
		local win1=c:GetSequence()
		Duel.MoveSequence(c,seq)
		local win2=c:GetSequence()
		if win1~=win2 then
			win=true
		else
			return c101108047.cannot_move(c)
		end
	end
	if win and winct then
		Duel.Win(tp,WIN_REASON_SEKITORI) 
	end
end